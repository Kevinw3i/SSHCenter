# frozen_string_literal: true

module Api
  module V1
    class ServersController < ApplicationController
      before_action :set_server, only: [:update]

      def index
        authorize Server
        servers = policy_scope(Server).includes(:server_group).order(:id)
        render json: { servers: servers.map { |server| server_payload(server) } }
      end

      def admin_index
        authorize Server, :admin_index?
        servers = Server.includes(:server_group).order(:id)
        render json: { servers: servers.map { |server| server_payload(server) } }
      end

      def create
        authorize Server
        server = Server.new(server_params)

        if server.save
          render json: { server: server_payload(server) }, status: :created
        else
          render json: { error: server.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @server
        if @server.update(server_params)
          render json: { server: server_payload(@server) }
        else
          render json: { error: @server.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_server
        @server = Server.find(params[:id])
      end

      def server_params
        params.require(:server).permit(:site, :env, :role, :ip, :server_group_id)
      end

      def server_payload(server)
        {
          id: server.id,
          site: server.site,
          env: server.env,
          role: server.role,
          ip: server.ip,
          server_group: {
            id: server.server_group_id,
            name: server.server_group&.name
          }
        }
      end
    end
  end
end
