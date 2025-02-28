# frozen_string_literal: true

class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, { student: 0, teacher: 1, dean: 2 }
  belongs_to :status
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  validates :username, presence: true, uniqueness: true
  validates :lastname, presence: true
  validates :firstname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  
  attr_accessor :new_status_name

  before_validation :create_or_set_status
  
  # Check if user is authorized to manage users
  def can_manage_users?
    dean?
  end
  
  # Check if user can manage specific role
  def can_manage_role?(target_role)
    return false unless dean?
    
    case target_role.to_sym
    when :student, :teacher, :dean
      true
    else
      false
    end
  end
  
  def full_name
    "#{firstname} #{lastname}"
  end

  private

  def create_or_set_status
    return unless new_status_name.present?
    
    self.status = Status.find_or_create_by!(title: new_status_name.strip)
  end
end
