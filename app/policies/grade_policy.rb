# frozen_string_literal: true

class GradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can only see grades for their courses
        scope.joins(examination: :course)
             .where(courses: { teacher_id: user.id })
      else
        # Students can only see their own grades
        scope.where(student_id: user.id)
      end
    end
  end

  def index?
    true # Everyone can see grades list (filtered by policy scope)
  end

  def show?
    return true if dean?
    return true if teacher? && record.examination.course.teacher_id == user.id
    student? && record.student_id == user.id
  end

  def create?
    return true if dean?
    # Teachers can only create grades for their own courses
    teacher? && record.examination.course.teacher_id == user.id
  end

  def update?
    return true if dean?
    # Teachers can only update grades for their own courses
    teacher? && record.examination.course.teacher_id == user.id
  end

  def destroy?
    dean? # Only deans can delete grades
  end
end 