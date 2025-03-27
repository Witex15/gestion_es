# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      else
        # Teachers and students can view all rooms
        scope.all
      end
    end
  end

  def index?
    true # Everyone can see rooms list
  end

  def show?
    true # Everyone can view room details
  end

  def create?
    dean? # Only deans can create rooms
  end

  def update?
    dean? # Only deans can update rooms
  end

  def destroy?
    dean? # Only deans can delete rooms
  end
end 