# frozen_string_literal: true

module Api
  module V1
    class ServerGroupsController < ApplicationController
      before_action :set_server_group, only: [:update, :destroy]

      def index
        authorize ServerGroup
        groups = policy_scope(ServerGroup).order(:name)
        render json: { server_groups: groups }
      end

      def create
        authorize ServerGroup
        group = ServerGroup.new(server_group_params)

        if group.save
          render json: { server_group: group }, status: :created
        else
          render json: { error: group.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @server_group
        if @server_group.update(server_group_params)
          render json: { server_group: @server_group }
        else
          render json: { error: @server_group.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @server_group
        @server_group.destroy
        head :no_content
      end

      private

      def set_server_group
        @server_group = ServerGroup.find(params[:id])
      end

      def server_group_params
        params.require(:server_group).permit(:name)
      end
    end
  end
end
