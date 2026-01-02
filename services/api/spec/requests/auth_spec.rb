# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth", type: :request do
  let(:password) { "password123" }
  let(:user) { User.create!(username: "demo", password: password) }

  describe "POST /api/v1/auth/login" do
    it "returns jwt with valid otp" do
      otp_code = ROTP::TOTP.new(user.otp_secret, issuer: "SSCenter").now

      post "/api/v1/auth/login", params: {
        user: {
          username: user.username,
          password: password,
          otp_code: otp_code
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to match(/Bearer /)
    end

    it "rejects invalid otp" do
      post "/api/v1/auth/login", params: {
        user: {
          username: user.username,
          password: password,
          otp_code: "000000"
        }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/auth/me" do
    it "returns current user" do
      get "/api/v1/auth/me", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("user", "id")).to eq(user.id)
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    it "returns no content" do
      delete "/api/v1/auth/logout", headers: auth_headers(user)

      expect(response).to have_http_status(:no_content)
    end
  end
end
