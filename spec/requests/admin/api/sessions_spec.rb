require "rails_helper"

RSpec.describe "Admin::Api::SessionsController", type: :request do
  before do
    @admin = FactoryBot.create(:admin, email: "admin@example.com", password: "123456")
  end

  describe "POST: /admin/api/sign_in" do
    it "[SUCCESS] Valid parameters" do
      params = {}
      params["email"] = "admin@example.com"
      params["password"] = "123456"
      post "/admin/api/sign_in", params: params
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"auth_token\"")
      expect(response.body).to include("\"email\"")
    end

    it "[FAIL] Invalid email" do
      params = {}
      params["email"] = "def@gmail.com"
      params["password"] = "123456"
      post "/admin/api/sign_in", params: params
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] Invalid password" do
      params = {}
      params["email"] = "admin@example.com"
      params["password"] = "123456789"
      post "/admin/api/sign_in", params: params
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end
end
