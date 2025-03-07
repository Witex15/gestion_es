class Moment < ApplicationRecord
  # Define the types of academic periods
  enum :moment_type, { quarter: 0, semester: 1, year: 2 }
  
  # Validations
  validates :start_on, presence: true
  validates :end_on, presence: true
  validates :moment_type, presence: true
  
  validate :end_date_after_start_date
  
  def display_name
    "#{moment_type.titleize} (#{start_on.strftime('%B %Y')} - #{end_on.strftime('%B %Y')})"
  end
  
  private
  
  def end_date_after_start_date
    return if start_on.blank? || end_on.blank?
    
    if end_on < start_on
      errors.add(:end_on, "must be after the start date")
    end
  end
end
