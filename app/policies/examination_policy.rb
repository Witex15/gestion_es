# frozen_string_literal: true

class ExaminationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        scope.joins(:course).where(courses: { teacher_id: user.id })
      else
        scope.joins(course: { school_class: :students_classes })
             .where(course: { school_class: { students_classes: { student_id: user.id } } })
      end
    end
  end

  def index?
    true # Everyone can see examinations list (filtered by policy scope)
  end

  def show?
    return true if dean?
    return true if teacher? && record.course.teacher_id == user.id
    student? && record.course.school_class.students_classes.exists?(student_id: user.id)
  end

  def create?
    teacher? || dean?
  end

  def update?
    teacher? && record.course.teacher_id == user.id || dean?
  end

  def destroy?
    dean?
  end
end 