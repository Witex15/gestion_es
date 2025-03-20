class PromotionAssertsController < ApplicationController
  before_action :set_promotion_assert, only: %i[ show edit update destroy ]

  # GET /promotion_asserts or /promotion_asserts.json
  def index
    @promotion_asserts = policy_scope(PromotionAssert)
    authorize PromotionAssert
  end

  # GET /promotion_asserts/1 or /promotion_asserts/1.json
  def show
    authorize @promotion_assert
    @student = Person.find(params[:student_id]) if params[:student_id].present?
  end

  # GET /promotion_asserts/new
  def new
    @promotion_assert = PromotionAssert.new
    authorize @promotion_assert
  end

  # GET /promotion_asserts/1/edit
  def edit
    authorize @promotion_assert
  end

  # POST /promotion_asserts or /promotion_asserts.json
  def create
    @promotion_assert = PromotionAssert.new(promotion_assert_params)
    authorize @promotion_assert

    respond_to do |format|
      if @promotion_assert.save
        format.html { redirect_to promotion_assert_url(@promotion_assert), notice: "Promotion assert was successfully created." }
        format.json { render :show, status: :created, location: @promotion_assert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @promotion_assert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotion_asserts/1 or /promotion_asserts/1.json
  def update
    authorize @promotion_assert
    
    respond_to do |format|
      if @promotion_assert.update(promotion_assert_params)
        format.html { redirect_to promotion_assert_url(@promotion_assert), notice: "Promotion assert was successfully updated." }
        format.json { render :show, status: :ok, location: @promotion_assert }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @promotion_assert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promotion_asserts/1 or /promotion_asserts/1.json
  def destroy
    authorize @promotion_assert
    
    @promotion_assert.destroy

    respond_to do |format|
      format.html { redirect_to promotion_asserts_url, notice: "Promotion assert was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion_assert
    @promotion_assert = PromotionAssert.active.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def promotion_assert_params
      params.require(:promotion_assert).permit(:description, :function, :moment_id, :sector_id)
    end
end
