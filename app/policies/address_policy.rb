# frozen_string_literal: true

class AddressPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # Everyone can see all addresses
    end
  end

  def index?
    dean? # Only deans can see addresses list
  end

  def show?
    true # Everyone can view address details
  end

  def create?
    dean? # Only deans can create addresses
  end

  def update?
    dean? # Only deans can update addresses
  end

  def destroy?
    dean? # Only deans can delete addresses
  end
  
  def search?
    true # Everyone can search addresses
  end
end 