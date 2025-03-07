class MomentsController < ApplicationController
  before_action :require_dean
  before_action :set_moment, only: %i[ show edit update destroy ]

  # GET /moments or /moments.json
  def index
    @moments = Moment.all.order(start_on: :desc)
  end

  # GET /moments/1 or /moments/1.json
  def show
  end

  # GET /moments/new
  def new
    @moment = Moment.new
  end

  # GET /moments/1/edit
  def edit
  end

  # POST /moments or /moments.json
  def create
    @moment = Moment.new(moment_params)

    respond_to do |format|
      if @moment.save
        format.html { redirect_to moments_path, notice: "#{@moment.moment_type.titleize} was successfully created." }
        format.json { render :show, status: :created, location: @moment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moments/1 or /moments/1.json
  def update
    respond_to do |format|
      if @moment.update(moment_params)
        format.html { redirect_to moments_path, notice: "#{@moment.moment_type.titleize} was successfully updated." }
        format.json { render :show, status: :ok, location: @moment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moments/1 or /moments/1.json
  def destroy
    moment_type = @moment.moment_type.titleize
    @moment.destroy!

    respond_to do |format|
      format.html { redirect_to moments_path, status: :see_other, notice: "#{moment_type} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def require_dean
      unless current_person&.dean?
        flash[:alert] = "Only deans can manage academic periods."
        redirect_to root_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_moment
      @moment = Moment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def moment_params
      params.require(:moment).permit(:start_on, :end_on, :moment_type)
    end
end
