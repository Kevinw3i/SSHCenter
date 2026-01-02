# frozen_string_literal: true

module Api
  module V1
    class GroupMembershipsController < ApplicationController
      before_action :set_membership, only: [:destroy]

      def index
        authorize GroupMembership
        memberships = policy_scope(GroupMembership).includes(:user, :server_group).order(:id)
        render json: { group_memberships: memberships.map { |membership| membership_payload(membership) } }
      end

      def create
        authorize GroupMembership
        membership = GroupMembership.new(group_membership_params)

        if membership.save
          render json: { group_membership: membership_payload(membership) }, status: :created
        else
          render json: { error: membership.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @membership
        @membership.destroy
        head :no_content
      end

      private

      def set_membership
        @membership = GroupMembership.find(params[:id])
      end

      def group_membership_params
        params.require(:group_membership).permit(:user_id, :server_group_id)
      end

      def membership_payload(membership)
        {
          id: membership.id,
          user: {
            id: membership.user_id,
            username: membership.user&.username
          },
          server_group: {
            id: membership.server_group_id,
            name: membership.server_group&.name
          }
        }
      end
    end
  end
end
