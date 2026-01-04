# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Servers", type: :request do
  let(:admin) { User.create!(username: "admin", password: "password123", role: :admin) }
  let(:user) { User.create!(username: "user1", password: "password123", role: :user) }

  describe "GET /api/v1/servers" do
    it "returns only servers assigned via groups" do
      group_a = ServerGroup.create!(name: "Group A")
      group_b = ServerGroup.create!(name: "Group B")
      server_a = Server.create!(server_group: group_a, site: "SiteA", env: "Prod", role: "web", ip: "10.0.0.1")
      Server.create!(server_group: group_b, site: "SiteB", env: "Prod", role: "db", ip: "10.0.0.2")
      GroupMembership.create!(user: user, server_group: group_a)

      get "/api/v1/servers", headers: auth_headers(user)

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body["servers"].map { |item| item["id"] }).to eq([server_a.id])
    end
  end

  describe "GET /api/v1/admin/servers" do
    it "allows admin to list all" do
      group = ServerGroup.create!(name: "Group A")
      Server.create!(server_group: group, site: "SiteA", env: "Prod", role: "web", ip: "10.0.0.1")

      get "/api/v1/admin/servers", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["servers"].size).to be >= 1
    end
  end

  describe "POST /api/v1/servers" do
    it "allows admin to create a server without a group" do
      post "/api/v1/servers",
        headers: auth_headers(admin),
        params: { server: { site: "SiteA", env: "Prod", role: "web", ip: "10.0.0.9" } }

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(body.dig("server", "server_group", "id")).to be_nil
    end

    it "rejects invalid ip addresses" do
      post "/api/v1/servers",
        headers: auth_headers(admin),
        params: { server: { site: "SiteA", env: "Prod", role: "web", ip: "999.999.1.1" } }

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(body["error"]).to include("Ip is invalid")
    end

    it "normalizes server fields" do
      post "/api/v1/servers",
        headers: auth_headers(admin),
        params: { server: { site: " SiteA ", env: " Prod ", role: " web ", ip: " 10.0.0.9 " } }

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(body.dig("server", "site")).to eq("SiteA")
      expect(body.dig("server", "env")).to eq("Prod")
      expect(body.dig("server", "role")).to eq("web")
      expect(body.dig("server", "ip")).to eq("10.0.0.9")
    end
  end

  describe "PATCH /api/v1/servers/:id" do
    it "returns not found when server does not exist" do
      patch "/api/v1/servers/0",
        headers: auth_headers(admin),
        params: { server: { env: "Staging" } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("not_found")
    end
  end

  describe "DELETE /api/v1/servers/:id" do
    it "allows admin to delete a server" do
      group = ServerGroup.create!(name: "Group A")
      server = Server.create!(server_group: group, site: "SiteA", env: "Prod", role: "web", ip: "10.0.0.1")

      delete "/api/v1/servers/#{server.id}", headers: auth_headers(admin)

      expect(response).to have_http_status(:no_content)
      expect(Server.exists?(server.id)).to be(false)
    end

    it "returns not found when server does not exist" do
      delete "/api/v1/servers/0", headers: auth_headers(admin)

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("not_found")
    end
  end
end
