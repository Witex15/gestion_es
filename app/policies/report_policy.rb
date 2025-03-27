# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Teachers can only see reports for their courses
        scope.where(teacher_id: user.id)
      else
        # Students can only see their own reports
        scope.where(student_id: user.id)
      end
    end
  end

  def index?
    true # Everyone can access reports, but they'll be filtered by scope
  end

  def export_pdf?
    # Students can export their own reports
    return true if user.student?
    
    # Deans can export any student's report
    return true if user.dean?
    
    false
  end
end 