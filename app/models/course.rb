class Course < ApplicationRecord
  belongs_to :subject
  belongs_to :school_class
  belongs_to :moment
  belongs_to :teacher
end
