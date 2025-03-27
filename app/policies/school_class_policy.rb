# frozen_string_literal: true

class SchoolClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can see all classes but cannot modify them
        scope.all
      else
        # Students can only see their enrolled classes
        scope.joins(:students_classes)
             .where(students_classes: { student_id: user.id })
      end
    end
  end

  def index?
    true # Everyone can see classes list (filtered by policy scope)
  end

  def show?
    true # Everyone can view class details
  end

  def create?
    dean? # Only deans can create classes
  end

  def update?
    dean? # Only deans can update classes
  end

  def destroy?
    dean? # Only deans can delete classes
  end

  def manage_students?
    dean? # Only deans can manage student enrollments
  end

  def update_students?
    dean? # Only deans can update student enrollments
  end
end 