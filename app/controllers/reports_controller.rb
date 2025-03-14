class ReportsController < ApplicationController
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