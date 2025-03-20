class Sector < ApplicationRecord
  has_many :school_classes, -> { where(deleted_at: nil) }
  has_many :promotion_asserts, -> { where(deleted_at: nil) }
end
