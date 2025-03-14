# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can see all courses but can only manage their own
        scope.all
      else
        # Students can only see courses they're enrolled in
        scope.joins(school_class: :students_classes)
             .where(school_class: { students_classes: { student_id: user.id } })
      end
    end
  end

  def index?
    true # Everyone can see courses list (filtered by policy scope)
  end

  def show?
    true # Everyone can view course details
  end

  def create?
    dean? # Only deans can create courses
  end

  def update?
    dean? || (teacher? && record.teacher_id == user.id) # Deans or teachers who own the course
  end

  def edit?
    dean? || (teacher? && record.teacher_id == user.id) # Deans or teachers who own the course
  end

  def destroy?
    dean? # Only deans can delete courses
  end

  def manage_students?
    dean? # Only deans can manage student enrollments
  end
end 