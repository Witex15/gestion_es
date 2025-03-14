# frozen_string_literal: true

class PeopleController < ApplicationController
  skip_before_action :authenticate_person!, only: [:new, :create], if: :first_user_creation?
  before_action :set_person, only: %i[show edit update destroy]
  before_action :authorize_user_management, except: [:index, :show]
  before_action :load_statuses, only: [:new, :edit, :create, :update]
  
  # GET /people or /people.json
  def index
    @people = policy_scope(Person)
    authorize Person
  end

  # GET /people/1 or /people/1.json
  def show
    authorize @person
  end

  # GET /people/new
  def new
    @person = Person.new
    @person.build_address
    authorize @person
  end

  # GET /people/1/edit
  def edit
    authorize @person
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    authorize @person

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
    authorize @person
    
    # Only allow role changes if user has permission
    if person_params[:role].present?
      authorize @person, :manage_role?
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
    authorize @person
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_path, notice: "Person was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

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
