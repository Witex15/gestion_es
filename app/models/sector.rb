class Sector < ApplicationRecord
  has_many :school_classes
  has_many :promotion_asserts
end
