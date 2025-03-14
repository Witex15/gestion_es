# frozen_string_literal: true

class SubjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      else
        # Teachers and students can view all subjects
        scope.all
      end
    end
  end

  def index?
    true # Everyone can see subjects list
  end

  def show?
    true # Everyone can view subject details
  end

  def create?
    dean? # Only deans can create subjects
  end

  def update?
    dean? # Only deans can update subjects
  end

  def destroy?
    dean? # Only deans can delete subjects
  end
end 