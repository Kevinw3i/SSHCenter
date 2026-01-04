class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def user_payload(user)
    {
      id: user.id,
      username: user.username,
      role: user.role,
      open_mode: user.open_mode,
      ssh_public_key: user.ssh_public_key,
      otp_required_for_login: user.otp_required_for_login
    }
  end

  def user_not_authorized
    render json: { error: "not_authorized" }, status: :forbidden
  end

  def record_not_found
    render json: { error: "not_found" }, status: :not_found
  end
end
