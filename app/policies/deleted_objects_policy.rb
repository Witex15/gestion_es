class DeletedObjectsPolicy < ApplicationPolicy
  def index?
    dean?
  end

  def restore?
    dean?
  end

  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      else
        scope.none
      end
    end
  end
end 