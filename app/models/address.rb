# frozen_string_literal: true

class Address < ApplicationRecord
  validates :street, :town, :zip, :number, presence: true

  def to_s
    "#{street} #{number}, #{zip} #{town}"
  end
end
