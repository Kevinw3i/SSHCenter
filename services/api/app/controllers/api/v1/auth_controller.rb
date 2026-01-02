# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      def me
        render json: {
          user: user_payload(current_user),
          ip: request.remote_ip,
          server_groups: current_user.server_groups.select(:id, :name)
        }
      end
    end
  end
end
