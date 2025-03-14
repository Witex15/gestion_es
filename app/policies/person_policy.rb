# frozen_string_literal: true

class PersonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can only view students and other teachers
        scope.where(role: [:student, :teacher])
      else
        # Students can only view their own profile
        scope.where(id: user.id)
      end
    end
  end

  def index?
    # Both deans and teachers can view the people list (but teachers see limited data)
    dean? || teacher?
  end

  def show?
    dean? || record.id == user.id || (teacher? && record.student?)
  end

  def create?
    dean? # Only deans can create users
  end

  def update?
    if dean?
      true # Deans can update anyone
    elsif record.id == user.id
      # Users can update their own profiles, but can't change their role
      !user.role_changed?
    else
      false
    end
  end

  def destroy?
    dean? && !record.dean? # Only deans can delete users, but can't delete other deans
  end

  def manage_role?
    dean? # Only deans can manage roles
  end
end 