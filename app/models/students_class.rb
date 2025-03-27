class StudentsClass < ApplicationRecord
  belongs_to :student, -> { where(deleted_at: nil) }, class_name: 'Person'
  belongs_to :school_class, -> { where(deleted_at: nil) }
end
