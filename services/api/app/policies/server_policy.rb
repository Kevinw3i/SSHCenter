# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def admin_index?
    admin_or_manage?
  end

  def create?
    admin_or_manage?
  end

  def update?
    admin_or_manage?
  end

  def destroy?
    admin_or_manage?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.role_admin? || user&.role_manage?

      scope.where(server_group_id: user.server_group_ids)
    end
  end
end
