# frozen_string_literal: true

class Status < ApplicationRecord
  has_many :people, dependent: :restrict_with_error
  
  validates :title, presence: true, uniqueness: true

  def to_s
    title
  end
end
