# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GroupMemberships", type: :request do
  let(:admin) { User.create!(username: "admin", password: "password123", role: :admin) }

  describe "POST /api/v1/group_memberships" do
    it "assigns group to user" do
      user = User.create!(username: "user1", password: "password123", role: :user)
      group = ServerGroup.create!(name: "Group A")

      post "/api/v1/group_memberships",
        headers: auth_headers(admin),
        params: { group_membership: { user_id: user.id, server_group_id: group.id } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).dig("group_membership", "user", "id")).to eq(user.id)
    end
  end

  describe "GET /api/v1/group_memberships" do
    it "lists memberships" do
      user = User.create!(username: "user1", password: "password123", role: :user)
      group = ServerGroup.create!(name: "Group A")
      GroupMembership.create!(user: user, server_group: group)

      get "/api/v1/group_memberships", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["group_memberships"].size).to be >= 1
    end
  end
end
