# frozen_string_literal: true

class HomePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true # Everyone can access the home page
  end
end 