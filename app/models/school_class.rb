class SchoolClass < ApplicationRecord
  belongs_to :moment, -> { where(deleted_at: nil) }
  belongs_to :room, -> { where(deleted_at: nil) }
  belongs_to :master, -> { where(deleted_at: nil) }, class_name: 'Person'
  belongs_to :sector, -> { where(deleted_at: nil) }

  has_many :students_classes, -> { where(deleted_at: nil) }
  has_many :students, -> { where(deleted_at: nil) }, through: :students_classes, source: :student, class_name: 'Person'
end
