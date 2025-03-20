class GradesController < ApplicationController
  before_action :set_grade, only: %i[ show edit update destroy ]

  # GET /grades or /grades.json
  def index
    @grades = policy_scope(Grade.includes(:examination, :student))
    authorize Grade
  end

  # GET /grades/1 or /grades/1.json
  def show
    authorize @grade
  end

  # GET /grades/new
  def new
    @grade = Grade.new
    authorize @grade
    
    @examinations = Examination.active.includes(course: [:subject, :school_class])
                             .where(courses: { archived: false })
                             .order(effective_date: :desc)
    @students = Person.active.where(role: :student)
  end

  # GET /grades/1/edit
  def edit
    authorize @grade
    
    @examinations = Examination.active.includes(course: [:subject, :school_class])
                             .where(courses: { archived: false })
                             .order(effective_date: :desc)
    @students = Person.active.where(role: :student)
  end

  # POST /grades or /grades.json
  def create
    @grade = Grade.new(grade_params)
    authorize @grade
    
    if @grade.save
      redirect_to @grade, notice: "Grade was successfully created."
    else
      @examinations = Examination.active.includes(course: [:subject, :school_class])
                               .where(courses: { archived: false })
                               .order(effective_date: :desc)
      @students = Person.active.where(role: :student)
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grades/1 or /grades/1.json
  def update
    authorize @grade
    
    if @grade.update(grade_params)
      redirect_to @grade, notice: "Grade was successfully updated."
    else
      @examinations = Examination.active.includes(course: [:subject, :school_class])
                               .where(courses: { archived: false })
                               .order(effective_date: :desc)
      @students = Person.active.where(role: :student)
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /grades/1 or /grades/1.json
  def destroy
    authorize @grade
    
    @grade.destroy
    redirect_to grades_path, notice: "Grade was successfully deleted.", status: :see_other
  end

  private
    def set_grade
      @grade = Grade.includes(:examination, :student).find(params[:id])
    end

    def grade_params
      params.require(:grade).permit(:examination_id, :student_id, :value, :execute_on)
    end
end
