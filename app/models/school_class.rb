class SchoolClass < ApplicationRecord
  belongs_to :moment
  belongs_to :room
  belongs_to :master, class_name: 'Person'
  belongs_to :sector

  has_many :students_classes
  has_many :students, through: :students_classes, source: :student, class_name: 'Person'
end
