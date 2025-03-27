# frozen_string_literal: true

class StatusPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # Everyone can see all statuses
    end
  end

  def index?
    true # Everyone can see statuses list
  end

  def show?
    true # Everyone can view status details
  end

  def create?
    dean? # Only deans can create statuses
  end

  def update?
    dean? # Only deans can update statuses
  end

  def destroy?
    dean? # Only deans can delete statuses
  end
  
  def search?
    true # Everyone can search statuses
  end
end 