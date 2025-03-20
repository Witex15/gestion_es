class Examination < ApplicationRecord
  belongs_to :course, -> { where(deleted_at: nil) }
end
