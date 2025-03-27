# frozen_string_literal: true

class PromotionAssertPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can see all promotion asserts but cannot modify them
        scope.all
      else
        # Students can see promotion asserts for their sectors
        scope.joins(sector: { school_classes: :students })
             .where(students: { id: user.id })
             .distinct
      end
    end
  end

  def index?
    true # Everyone can see promotion asserts list (filtered by scope)
  end

  def show?
    if dean?
      true
    elsif teacher?
      true # Teachers can view all promotion asserts
    else
      # Students can only view promotion asserts for their sectors
      record.sector.school_classes.joins(:students).where(students: { id: user.id }).exists?
    end
  end

  def create?
    dean? # Only deans can create promotion asserts
  end

  def update?
    dean? # Only deans can update promotion asserts
  end

  def destroy?
    dean? # Only deans can delete promotion asserts
  end
end 