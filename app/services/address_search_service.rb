# frozen_string_literal: true

# Single Responsibility Principle: This service handles only address searching
class AddressSearchService
  def self.call(query)
    new(query).call
  end

  def initialize(query)
    @query = query.to_s.downcase
  end

  def call
    return Address.none if @query.blank?

    Address.where("LOWER(street) LIKE :query OR LOWER(city) LIKE :query OR postal_code LIKE :query",
                 query: "%#{@query}%")
          .limit(10)
  end
end 