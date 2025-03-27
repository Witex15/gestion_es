# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_address, only: %i[ show edit update destroy ]

  # GET /addresses or /addresses.json
  def index
    @addresses = policy_scope(Address)
    authorize Address
  end

  # GET /addresses/1 or /addresses/1.json
  def show
    authorize @address
  end

  # GET /addresses/new
  def new
    @address = Address.new
    authorize @address
    
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("modal", partial: "addresses/inline_form") }
    end
  end

  # GET /addresses/1/edit
  def edit
    authorize @address
  end

  # POST /addresses or /addresses.json
  def create
    @address = Address.new(address_params)
    authorize @address

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: "Address was successfully created." }
        format.json { render json: @address, status: :created }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("modal", "")
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("modal", partial: "addresses/inline_form")
        }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    authorize @address
    
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    authorize @address
    
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_path, status: :see_other, notice: "Address was successfully deleted." }
      format.json { head :no_content }
    end
  end

  # Interface Segregation Principle: Separate search functionality
  def search
    authorize Address, :search?
    @addresses = AddressSearchService.call(params[:query])
    render json: @addresses
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
    @address = Address.active.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def address_params
      params.require(:address).permit(:street, :city, :postal_code)
    end
end
