# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    admin_or_manage?
  end

  def create?
    admin_or_manage?
  end

  def update?
    admin_or_manage?
  end

  def otp_qr?
    admin_or_manage?
  end

  def me_update?
    user.id == record.id
  end

  def me_password?
    user.id == record.id
  end

  def me_ssh_key?
    user.id == record.id
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.role_admin? || user&.role_manage?

      scope.where(id: user.id)
    end
  end
end
