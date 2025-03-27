class ExaminationsController < ApplicationController
  before_action :set_examination, only: %i[ show edit update destroy students ]

  # GET /examinations or /examinations.json
  def index
    @examinations = policy_scope(Examination)
    authorize Examination
  end

  # GET /examinations/1 or /examinations/1.json
  def show
    authorize @examination
  end

  # GET /examinations/new
  def new
    @examination = Examination.new
    authorize @examination
  end

  # GET /examinations/1/edit
  def edit
    authorize @examination
  end

  # POST /examinations or /examinations.json
  def create
    @examination = Examination.new(examination_params)
    authorize @examination

    respond_to do |format|
      if @examination.save
        format.html { redirect_to @examination, notice: "Examination was successfully created." }
        format.json { render :show, status: :created, location: @examination }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examinations/1 or /examinations/1.json
  def update
    authorize @examination
    
    respond_to do |format|
      if @examination.update(examination_params)
        format.html { redirect_to @examination, notice: "Examination was successfully updated." }
        format.json { render :show, status: :ok, location: @examination }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examinations/1 or /examinations/1.json
  def destroy
    authorize @examination
    
    @examination.destroy

    respond_to do |format|
      format.html { redirect_to examinations_path, status: :see_other, notice: "Examination was successfully deleted." }
      format.json { head :no_content }
    end
  end

  # GET /examinations/:id/students
  def students
    authorize @examination, :show?
    
    begin
      @students = @examination.course.school_class.students_classes.includes(:student)
                            .joins(:student)
                            .where(students: { role: :student })
                            .map(&:student)
      
      Rails.logger.debug "Found examination: #{@examination.inspect}"
      Rails.logger.debug "School class: #{@examination.course.school_class.inspect}"
      Rails.logger.debug "Found students: #{@students.inspect}"
      
      render json: @students.map { |student| { id: student.id, full_name: student.full_name } }
    rescue => e
      Rails.logger.error "Error in students action: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: "Could not load students: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examination
      @examination = Examination.includes(course: { school_class: :students_classes }).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def examination_params
      params.require(:examination).permit(:title, :effective_date, :course_id)
    end
end
