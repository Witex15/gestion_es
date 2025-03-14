class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: %i[ show edit update destroy manage_students update_students ]

  # GET /school_classes or /school_classes.json
  def index
    @school_classes = policy_scope(SchoolClass)
    authorize SchoolClass
  end

  # GET /school_classes/1 or /school_classes/1.json
  def show
    authorize @school_class
  end

  # GET /school_classes/new
  def new
    @school_class = SchoolClass.new
    authorize @school_class
  end

  # GET /school_classes/1/edit
  def edit
    authorize @school_class
  end

  # GET /school_classes/1/manage_students
  def manage_students
    authorize @school_class, :manage_students?
    @available_students = Person.where(role: :student)
    @enrolled_students = @school_class.students
  end

  # POST /school_classes/1/update_students
  def update_students
    authorize @school_class, :update_students?
    student_ids = params[:student_ids] || []
    
    # Remove all current enrollments
    @school_class.students_classes.destroy_all
    
    # Add new enrollments
    student_ids.each do |student_id|
      @school_class.students_classes.create(student_id: student_id)
    end
    
    redirect_to @school_class, notice: "Student enrollments updated successfully."
  rescue => e
    redirect_to manage_students_school_class_path(@school_class), 
                alert: "Error updating enrollments: #{e.message}"
  end

  # POST /school_classes or /school_classes.json
  def create
    @school_class = SchoolClass.new(school_class_params)
    authorize @school_class

    respond_to do |format|
      if @school_class.save
        format.html { redirect_to @school_class, notice: "School class was successfully created." }
        format.json { render :show, status: :created, location: @school_class }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_classes/1 or /school_classes/1.json
  def update
    authorize @school_class
    
    respond_to do |format|
      if @school_class.update(school_class_params)
        format.html { redirect_to @school_class, notice: "School class was successfully updated." }
        format.json { render :show, status: :ok, location: @school_class }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_classes/1 or /school_classes/1.json
  def destroy
    authorize @school_class
    @school_class.destroy!

    respond_to do |format|
      format.html { redirect_to school_classes_path, status: :see_other, notice: "School class was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_class
      @school_class = SchoolClass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_class_params
      params.require(:school_class).permit(:name, :moment_id, :room_id, :master_id, :sector_id)
    end
end
