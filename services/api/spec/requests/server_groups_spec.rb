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
  end

  describe "GET /api/v1/server_groups" do
    it "lists groups" do
      ServerGroup.create!(name: "Prod")
      get "/api/v1/server_groups", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["server_groups"].size).to be >= 1
    end
  end
end
