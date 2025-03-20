class Course < ApplicationRecord
  belongs_to :subject, -> { where(deleted_at: nil) }
  belongs_to :school_class, -> { where(deleted_at: nil) }
  belongs_to :moment, -> { where(deleted_at: nil) }
  belongs_to :teacher, -> { where(deleted_at: nil) }, class_name: 'Person'
end
