class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    @subjects = policy_scope(Subject)
    authorize Subject
  end

  # GET /subjects/1 or /subjects/1.json
  def show
    authorize @subject
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
    authorize @subject
  end

  # GET /subjects/1/edit
  def edit
    authorize @subject
  end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)
    authorize @subject

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: "Subject was successfully created." }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    authorize @subject
    
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: "Subject was successfully updated." }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    authorize @subject
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_path, status: :see_other, notice: "Subject was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
    @subject = Subject.active.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subject_params
      params.require(:subject).permit(:slug, :name)
    end
end
