# frozen_string_literal: true

class Status < ApplicationRecord
  has_many :people, -> { where(deleted_at: nil) }, dependent: :restrict_with_error
  
  validates :title, presence: true, uniqueness: true

  def to_s
    title
  end
end
