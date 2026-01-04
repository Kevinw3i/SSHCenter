# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ServerGroups", type: :request do
  let(:admin) { User.create!(username: "admin", password: "password123", role: :admin) }

  describe "POST /api/v1/server_groups" do
    it "creates a server group" do
      post "/api/v1/server_groups",
        headers: auth_headers(admin),
        params: { server_group: { name: "Prod" } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).dig("server_group", "name")).to eq("Prod")
    end

    it "normalizes group name" do
      post "/api/v1/server_groups",
        headers: auth_headers(admin),
        params: { server_group: { name: "  Production  " } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).dig("server_group", "name")).to eq("Production")
    end
  end

  describe "GET /api/v1/server_groups" do
    it "lists groups" do
      ServerGroup.create!(name: "Prod")
      get "/api/v1/server_groups", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["server_groups"].size).to be >= 1
    end
  end

  describe "PATCH /api/v1/server_groups/:id" do
    it "updates server assignments" do
      group = ServerGroup.create!(name: "Group A")
      other_group = ServerGroup.create!(name: "Group B")
      server_one = Server.create!(server_group: other_group, site: "SiteA", env: "Prod", role: "web", ip: "10.0.0.1")
      server_two = Server.create!(server_group: other_group, site: "SiteB", env: "Prod", role: "db", ip: "10.0.0.2")
      server_three = Server.create!(server_group: group, site: "SiteC", env: "Staging", role: "api", ip: "10.0.0.3")

      patch "/api/v1/server_groups/#{group.id}",
        headers: auth_headers(admin),
        params: { server_group: { server_ids: [server_one.id, server_two.id] } }

      expect(response).to have_http_status(:ok)
      expect(group.reload.servers.pluck(:id)).to match_array([server_one.id, server_two.id])
      expect(server_three.reload.server_group_id).to be_nil
    end

    it "returns not found when group does not exist" do
      patch "/api/v1/server_groups/0",
        headers: auth_headers(admin),
        params: { server_group: { name: "Missing" } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("not_found")
    end
  end

  describe "DELETE /api/v1/server_groups/:id" do
    it "returns not found when group does not exist" do
      delete "/api/v1/server_groups/0", headers: auth_headers(admin)

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("not_found")
    end
  end
end
