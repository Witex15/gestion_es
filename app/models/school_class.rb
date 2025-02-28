class SchoolClass < ApplicationRecord
  belongs_to :moment
  belongs_to :room
  belongs_to :master
  belongs_to :sector
end
