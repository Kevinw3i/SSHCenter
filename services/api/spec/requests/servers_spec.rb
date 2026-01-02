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
end
