class GradesController < ApplicationController
  before_action :set_grade, only: %i[ show edit update destroy ]
  before_action :authorize_grade_access, only: [:show]
  before_action :authorize_grade_management, only: [:new, :create, :edit, :update, :destroy]

  # GET /grades or /grades.json
  def index
    @grades = if current_person.student?
                Grade.joins(:examination)
                     .where(student_id: current_person.id)
                     .includes(examination: [:course])
              elsif current_person.teacher?
                Grade.joins(examination: :course)
                     .where(courses: { teacher_id: current_person.id })
                     .includes(examination: [:course])
              else
                Grade.all.includes(examination: [:course])
              end
  end

  # GET /grades/1 or /grades/1.json
  def show
  end

  # GET /grades/new
  def new
    @grade = Grade.new
    @available_examinations = current_person.teacher? ? 
      Examination.joins(:course).where(courses: { teacher_id: current_person.id }) :
      Examination.all
  end

  # GET /grades/1/edit
  def edit
  end

  # POST /grades or /grades.json
  def create
    @grade = Grade.new(grade_params)
    
    # Verify teacher owns the course
    unless current_person.dean? || @grade.examination.course.teacher_id == current_person.id
      return redirect_to grades_path, alert: "You can only add grades for your own courses."
    end

    respond_to do |format|
      if @grade.save
        format.html { redirect_to grade_url(@grade), notice: "Grade was successfully created." }
        format.json { render :show, status: :created, location: @grade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grades/1 or /grades/1.json
  def update
    # Verify teacher owns the course
    unless current_person.dean? || @grade.examination.course.teacher_id == current_person.id
      return redirect_to grades_path, alert: "You can only modify grades for your own courses."
    end

    respond_to do |format|
      if @grade.update(grade_params)
        format.html { redirect_to grade_url(@grade), notice: "Grade was successfully updated." }
        format.json { render :show, status: :ok, location: @grade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1 or /grades/1.json
  def destroy
    # Only deans can delete grades
    unless current_person.dean?
      return redirect_to grades_path, alert: "Only deans can delete grades."
    end

    @grade.destroy!

    respond_to do |format|
      format.html { redirect_to grades_path, notice: "Grade was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_grade
      @grade = Grade.find(params[:id])
    end

    def grade_params
      params.require(:grade).permit(:value, :execute_on, :examination_id, :student_id)
    end
    
    def authorize_grade_access
      unless current_person.dean? || 
             (current_person.teacher? && @grade.examination.course.teacher_id == current_person.id) ||
             (current_person.student? && @grade.student_id == current_person.id)
        redirect_to grades_path, alert: "You are not authorized to view this grade."
      end
    end
    
    def authorize_grade_management
      unless current_person.dean? || current_person.teacher?
        redirect_to grades_path, alert: "You are not authorized to manage grades."
      end
    end
end
