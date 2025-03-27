# frozen_string_literal: true

class MomentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can see all moments but cannot modify them
        scope.all
      else
        # Students can see all moments
        scope.all
      end
    end
  end

  def index?
    true # Everyone can see moments list
  end

  def show?
    true # Everyone can view moment details
  end

  def create?
    dean? # Only deans can create moments
  end

  def update?
    dean? # Only deans can update moments
  end

  def destroy?
    dean? # Only deans can delete moments
  end
end 