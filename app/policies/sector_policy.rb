# frozen_string_literal: true

class SectorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      else
        # Teachers and students can view all sectors
        scope.all
      end
    end
  end

  def index?
    true # Everyone can see sectors list
  end

  def show?
    true # Everyone can view sector details
  end

  def create?
    dean? # Only deans can create sectors
  end

  def update?
    dean? # Only deans can update sectors
  end

  def destroy?
    dean? # Only deans can delete sectors
  end
end 