class PromotionAssert < ApplicationRecord
  belongs_to :moment
  belongs_to :sector

  validates :description, presence: true
  validates :function, presence: true, inclusion: { 
    in: ['average_min_4', 'average_min_4.5', 'average_min_5', 'all_passed'],
    message: "%{value} is not a valid function" 
  }

  def check_promotion(student, shown_grades = nil)
    return false unless student.present?

    # Use shown grades if provided, otherwise query the database
    grades_to_check = if shown_grades.present?
                       shown_grades
                     else
                       Grade.joins(examination: { course: :school_class })
                           .where(student: student)
                           .where(examinations: { courses: { moment_id: moment_id }})
                           .where(examinations: { courses: { school_classes: { sector_id: sector_id }}})
                     end

    return false if grades_to_check.empty?

    values = grades_to_check.map(&:value)
    
    case function
    when 'average_min_4'
      values.sum.to_f / values.size >= 4.0
    when 'average_min_4.5'
      values.sum.to_f / values.size >= 4.5
    when 'average_min_5'
      values.sum.to_f / values.size >= 5.0
    when 'all_passed'
      values.all? { |grade| grade >= 4.0 }
    else
      false
    end
  end

  def function_description
    case function
    when 'average_min_4'
      'Average grade must be at least 4.0'
    when 'average_min_4.5'
      'Average grade must be at least 4.5'
    when 'average_min_5'
      'Average grade must be at least 5.0'
    when 'all_passed'
      'All grades must be at least 4.0'
    else
      'Unknown function'
    end
  end
end
