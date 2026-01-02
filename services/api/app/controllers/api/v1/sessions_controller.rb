# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        self.resource = warden.authenticate!(auth_options)
        if resource.otp_required_for_login? && !resource.valid_otp?(otp_code)
          sign_out resource
          return render json: { error: "invalid_otp" }, status: :unauthorized
        end

        sign_in(resource_name, resource)
        token = request.env["warden-jwt_auth.token"]
        response.headers["Authorization"] = "Bearer #{token}" if token.present?
        render json: { user: user_payload(resource), token: token }
      end

      def respond_to_on_destroy
        head :no_content
      end

      private

      def otp_code
        params.dig(:user, :otp_code) || params[:otp_code]
      end
    end
  end
end
