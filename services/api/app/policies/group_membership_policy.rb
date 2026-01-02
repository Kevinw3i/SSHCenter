# frozen_string_literal: true

class GroupMembershipPolicy < ApplicationPolicy
  def index?
    admin_or_manage?
  end

  def create?
    admin_or_manage?
  end

  def destroy?
    admin_or_manage?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.role_admin? || user&.role_manage?

      scope.none
    end
  end
end
