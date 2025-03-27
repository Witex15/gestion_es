# frozen_string_literal: true

# Single Responsibility Principle: This service handles only status searching
class StatusSearchService
  def self.call(query)
    new(query).call
  end

  def initialize(query)
    @query = query.to_s.downcase
  end

  def call
    return Status.none if @query.blank?

    Status.where("LOWER(name) LIKE :query", query: "%#{@query}%")
          .limit(10)
  end
end 