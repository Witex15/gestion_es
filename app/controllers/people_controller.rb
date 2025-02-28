# frozen_string_literal: true

class PeopleController < ApplicationController
  skip_before_action :authenticate_person!, only: [:new, :create], if: :first_user_creation?
  before_action :set_person, only: %i[ show edit update destroy ]
  before_action :authorize_user_management, except: [:show]
  before_action :load_statuses, only: [:new, :edit, :create, :update]
  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
    unless current_person == @person || current_person&.can_manage_users?
      redirect_to root_path, alert: "You are not authorized to view this profile."
    end
  end

  # GET /people/new
  def new
    if !current_person&.can_manage_users? && !first_user_creation?
      redirect_to root_path, alert: "You are not authorized to create new users."
      return
    end
    
    @person = Person.new
    @person.build_address
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    if !current_person&.can_manage_users? && !first_user_creation?
      redirect_to root_path, alert: "You are not authorized to create new users."
      return
    end

    @person = Person.new(person_params)
    
    # Skip role validation for first user or if user has permission
    unless Person.count.zero? || current_person&.can_manage_role?(@person.role)
      return redirect_to people_path, alert: "You are not authorized to create users with this role."
    end

    # Make first user a dean
    @person.role = :dean if Person.count.zero?

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    # Prevent role escalation
    if person_params[:role].present? && !current_person&.can_manage_role?(person_params[:role])
      return redirect_to people_path, alert: "You are not authorized to assign this role."
    end

    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    # Prevent deletion of last dean
    if @person.dean? && Person.where(role: :dean).count <= 1
      return redirect_to people_path, alert: "Cannot delete the last dean account."
    end

    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_path, notice: "Person was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(
        :username, :lastname, :firstname, :email, 
        :password, :password_confirmation,
        :phone_number, :iban, :role, :status_id, :new_status_name,
        address_attributes: [:id, :street, :number, :town, :zip]
      )
    end
    
    def authorize_user_management
      unless current_person&.can_manage_users?
        redirect_to root_path, alert: "You are not authorized to manage users."
      end
    end

    def load_statuses
      @statuses = Status.order(:title)
    end

    def first_user_creation?
      Person.count.zero?
    end
end
