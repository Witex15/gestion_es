class ReportsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_person!

  def index
    authorize :report
    @moments = Moment.all.order(start_on: :desc)
    
    @grades = case current_person.role
              when 'student'
                grades_query = Grade.includes(examination: { course: [:subject, :moment, :school_class] })
                     .where(student: current_person)
                     .order('examinations.effective_date DESC')
                filter_by_moment(grades_query)
              when 'teacher'
                grades_query = Grade.includes(:student, examination: { course: [:subject, :moment, :school_class] })
                     .joins(examination: :course)
                     .where(courses: { teacher_id: current_person.id })
                     .order('examinations.effective_date DESC')
                filter_by_moment(grades_query)
              when 'dean'
                @students = Person.student
                if params[:student_id].present?
                  grades_query = Grade.includes(examination: { course: [:subject, :moment, :school_class] })
                       .where(student_id: params[:student_id])
                       .order('examinations.effective_date DESC')
                  filter_by_moment(grades_query)
                else
                  Grade.none
                end
              end

    if params[:student_id].present? || current_person.student?
      @student = params[:student_id].present? ? Person.find(params[:student_id]) : current_person
      @moment = params[:moment_id].present? ? Moment.find(params[:moment_id]) : Moment.order(start_on: :desc).first
      
      if @moment
        # Get promotion asserts for the student's sectors in this moment
        @promotion_asserts = PromotionAssert.includes(:sector)
                                          .where(moment: @moment)
                                          .joins(sector: { school_classes: :students })
                                          .where(students: { id: @student.id })
                                          .distinct
                                          .map do |assert|
          # Get grades for this student in this moment and sector
          sector_grades = Grade.joins(examination: { course: :school_class })
                             .where(student: @student)
                             .where(examinations: { courses: { moment: @moment }})
                             .where(examinations: { courses: { school_classes: { sector_id: assert.sector_id }}})
                             .to_a

          # Add the sector's grades to the assert
          assert.instance_variable_set(:@shown_grades, sector_grades)
          assert.define_singleton_method(:shown_grades) { @shown_grades }
          assert
        end
      end
    end
  end

  def export_pdf
    authorize :report
    @student = Person.find(params[:student_id])
    
    # Additional authorization check for students
    if current_person.student? && current_person.id != @student.id
      raise Pundit::NotAuthorizedError, "Not allowed to export other student's reports"
    end
    
    @moment = params[:moment_id].present? ? Moment.find(params[:moment_id]) : Moment.order(start_on: :desc).first
    
    # Get grades for the student
    @grades = Grade.includes(examination: { course: [:subject, :moment, :school_class] })
                  .where(student_id: @student.id)
                  .order('examinations.effective_date DESC')
                  
    # Filter by moment if needed
    @grades = @grades.joins(examination: :course).where(courses: { moment_id: @moment.id }) if @moment
    
    # Get promotion asserts if available
    if @moment
      @promotion_asserts = PromotionAssert.includes(:sector)
                                         .where(moment: @moment)
                                         .joins(sector: { school_classes: :students })
                                         .where(students: { id: @student.id })
                                         .distinct
                                         .map do |assert|
        # Get grades for this student in this moment and sector
        sector_grades = Grade.joins(examination: { course: :school_class })
                           .where(student: @student)
                           .where(examinations: { courses: { moment: @moment }})
                           .where(examinations: { courses: { school_classes: { sector_id: assert.sector_id }}})
                           .to_a

        # Add the sector's grades to the assert
        assert.instance_variable_set(:@shown_grades, sector_grades)
        assert.define_singleton_method(:shown_grades) { @shown_grades }
        assert
      end
    end
    
    respond_to do |format|
      format.pdf do
        pdf = Prawn::Document.new(
          page_size: "A4",
          margin: [50, 50]
        )

        # Header
        pdf.text "Student Report", size: 24, style: :bold, align: :center
        pdf.move_down 20

        # Student Information
        pdf.text "Student: #{@student.full_name}", size: 14
        pdf.text "Period: #{@moment&.uid || 'All periods'}", size: 14
        pdf.move_down 20

        # Grades Table
        if @grades.any?
          pdf.text "Grades", size: 16, style: :bold
          pdf.move_down 10

          data = [["Subject", "Examination", "Date", "Grade"]]
          @grades.each do |grade|
            data << [
              grade.examination.course.subject.name,
              grade.examination.title,
              grade.examination.effective_date.strftime("%B %d, %Y"),
              grade.value.to_s
            ]
          end

          pdf.table(data, header: true) do |t|
            t.row(0).style(background_color: "CCCCCC", text_color: "000000", font_style: :bold)
            t.cells.style(size: 10, padding: 5)
            t.column_widths = [150, 150, 100, 50]
          end
          pdf.move_down 20
        end

        # Promotion Status
        if @promotion_asserts&.any?
          pdf.text "Promotion Status", size: 16, style: :bold
          pdf.move_down 10

          @promotion_asserts.each do |assert|
            sector_grades = @grades.select { |g| g.examination.course.school_class.sector_id == assert.sector_id }
            if sector_grades.any?
              avg = sector_grades.map(&:value).sum.to_f / sector_grades.size
              passed = assert.check_promotion(@student, sector_grades)
              
              pdf.text assert.sector.name, size: 14, style: :bold
              pdf.text "Function: #{assert.function_description}", size: 12
              pdf.text "Average: #{number_with_precision(avg, precision: 2)}", size: 12
              pdf.text "Status: #{passed ? 'Passed' : 'Not passed'}", size: 12, color: passed ? "00AA00" : "AA0000"
              pdf.move_down 10
            end
          end
        end

        send_data pdf.render,
                  filename: "student_report_#{@student.id}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  private

  def dean?
    current_person.dean?
  end

  def filter_by_moment(grades_query)
    if params[:moment_id].present?
      grades_query.joins(examination: :course).where(courses: { moment_id: params[:moment_id] })
    else
      grades_query
    end
  end
end 