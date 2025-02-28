class Grade < ApplicationRecord
  belongs_to :examination
  belongs_to :student, class_name: 'Person'
  
  validates :value, presence: true, 
                   numericality: { 
                     greater_than_or_equal_to: 1, 
                     less_than_or_equal_to: 6,
                     message: "must be between 1 and 6" 
                   }
  validates :execute_on, presence: true
  validates :student_id, uniqueness: { 
    scope: :examination_id,
    message: "already has a grade for this examination" 
  }
  
  validate :student_must_be_in_course
  validate :examination_must_not_be_in_archived_course
  
  private
  
  def student_must_be_in_course
    unless examination&.course&.school_class&.students&.include?(student)
      errors.add(:student, "must be enrolled in the course")
    end
  end
  
  def examination_must_not_be_in_archived_course
    if examination&.course&.archived?
      errors.add(:examination, "cannot add grades to archived courses")
    end
  end
end
