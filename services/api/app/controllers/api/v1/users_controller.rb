# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:update, :otp_qr]

      def index
        authorize User
        users = policy_scope(User).order(:id)
        render json: { users: users.map { |user| user_payload(user) } }
      end

      def create
        authorize User
        user = User.new(user_params)
        user.ensure_otp_secret!

        if user.save
          render json: { user: user_payload(user) }, status: :created
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @user
        apply_otp_reset(@user)

        if @user.update(user_params)
          render json: { user: user_payload(@user) }
        else
          render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def otp_qr
        authorize @user, :otp_qr?
        @user.ensure_otp_secret!
        @user.save! if @user.changed?

        qr_svg = RQRCode::QRCode.new(@user.otp_provisioning_uri).as_svg(
          offset: 0,
          color: "000000",
          shape_rendering: "crispEdges",
          module_size: 4
        )

        render json: {
          otp_provisioning_uri: @user.otp_provisioning_uri,
          qr_svg: qr_svg
        }
      end

      def me_update
        authorize current_user, :me_update?
        if current_user.update(me_params)
          render json: { user: user_payload(current_user) }
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me_password
        authorize current_user, :me_password?
        unless current_user.valid_password?(params[:current_password])
          return render json: { error: "invalid_current_password" }, status: :unauthorized
        end

        if current_user.update(password: params[:new_password])
          render json: { success: true }
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me_ssh_key
        authorize current_user, :me_ssh_key?
        if current_user.update(ssh_public_key: params[:ssh_public_key])
          render json: { user: user_payload(current_user) }
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :password, :role, :open_mode, :ssh_public_key, :otp_required_for_login)
      end

      def me_params
        params.require(:user).permit(:open_mode)
      end

      def apply_otp_reset(user)
        return unless ActiveModel::Type::Boolean.new.cast(params[:otp_reset])

        user.otp_secret = nil
        user.ensure_otp_secret!
      end
    end
  end
end
