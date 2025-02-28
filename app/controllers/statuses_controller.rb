# frozen_string_literal: true

class StatusesController < ApplicationController
  before_action :set_status, only: %i[ show edit update destroy ]

  # Interface Segregation Principle: Separate search functionality
  def search
    @statuses = StatusSearchService.call(params[:query])
    render json: @statuses
  end

  # GET /statuses or /statuses.json
  def index
    @statuses = Status.all
  end

  # GET /statuses/1 or /statuses/1.json
  def show
  end

  # GET /statuses/new
  def new
    @status = Status.new
    
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("modal", partial: "statuses/inline_form") }
    end
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses or /statuses.json
  def create
    @status = Status.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: "Status was successfully created." }
        format.json { render json: @status, status: :created }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("modal", "")
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("modal", partial: "statuses/inline_form")
        }
      end
    end
  end

  # PATCH/PUT /statuses/1 or /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to @status, notice: "Status was successfully updated." }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1 or /statuses/1.json
  def destroy
    @status.destroy!

    respond_to do |format|
      format.html { redirect_to statuses_path, status: :see_other, notice: "Status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def status_params
      params.require(:status).permit(:name)
    end
end
