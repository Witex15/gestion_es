class StudentsClass < ApplicationRecord
  belongs_to :student, class_name: 'Person'
  belongs_to :school_class
end
