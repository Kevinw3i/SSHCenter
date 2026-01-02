# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:admin) { User.create!(username: "admin", password: "password123", role: :admin) }
  let(:user) { User.create!(username: "user1", password: "password123", role: :user) }

  describe "GET /api/v1/users" do
    it "allows admin to list users" do
      user
      get "/api/v1/users", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["users"].size).to be >= 1
    end

    it "forbids non-admin" do
      get "/api/v1/users", headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/users" do
    it "creates user" do
      post "/api/v1/users",
        headers: auth_headers(admin),
        params: { user: { username: "newuser", password: "password123", role: "user" } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).dig("user", "username")).to eq("newuser")
    end
  end

  describe "PATCH /api/v1/users/:id" do
    it "updates user" do
      patch "/api/v1/users/#{user.id}",
        headers: auth_headers(admin),
        params: { user: { open_mode: "web" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("user", "open_mode")).to eq("web")
    end
  end

  describe "GET /api/v1/users/:id/otp_qr" do
    it "returns qr svg" do
      get "/api/v1/users/#{user.id}/otp_qr", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["qr_svg"]).to include("svg")
    end
  end

  describe "PATCH /api/v1/users/me" do
    it "updates open mode" do
      patch "/api/v1/users/me",
        headers: auth_headers(user),
        params: { user: { open_mode: "web" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("user", "open_mode")).to eq("web")
    end
  end

  describe "PATCH /api/v1/users/me/password" do
    it "updates password" do
      patch "/api/v1/users/me/password",
        headers: auth_headers(user),
        params: { current_password: "password123", new_password: "password456" }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/users/me/ssh_key" do
    it "updates ssh public key" do
      patch "/api/v1/users/me/ssh_key",
        headers: auth_headers(user),
        params: { ssh_public_key: "ssh-rsa AAA test" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("user", "ssh_public_key")).to eq("ssh-rsa AAA test")
    end
  end
end
