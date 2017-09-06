require "rails_helper"

RSpec.describe "Api::V1::UsersController", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "GET: /api/v1/users" do
    it "[SUCCESS] Valid parameters" do
      FactoryBot.create(:desired_worktime, user: @user, date: Date.current)
      get "/api/v1/users"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"users\"")
    end
  end

  describe "GET: /api/v1/users/{id}" do
    it "[SUCCESS] Valid parameters" do
      get "/api/v1/users/#{@user.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"user\"")
      expect(response.body).to include("\"desired_worktimes\"")
      expect(response.body).to include(@user.uid.to_s)
    end

    it "[FAIL] Invalid ID" do
      get "/api/v1/users/-1"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end
  end

  describe "GET: /api/v1/users/profile" do
    it "[SUCCESS] Valid parameters" do
      get "/api/v1/users/profile", headers: authenticated_header_for_user(@user)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"user\"")
      expect(response.body).to include(@user.uid.to_s)
    end

    it "[FAIL] Invalid jwt token" do
      get "/api/v1/users/profile", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No jwt token" do
      get "/api/v1/users/profile"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "PUT: /api/v1/users/profile" do
    it "[SUCCESS] Valid parameters" do
      user1 = FactoryBot.build(:user_with_updated_info)
      params = user1.as_json
      put "/api/v1/users/profile", headers: authenticated_header_for_user(@user), params: params
      expect(response.status).to eq 200
    end

    it "[FAIL] Invalid parameters" do
      user2 = FactoryBot.build(:user_with_updated_info)
      params = user2.as_json
      params["website_url"] = "zinza.com.vn"
      params["reference_url"] = "zinza.com.vn"
      put "/api/v1/users/profile", headers: authenticated_header_for_user(@user), params: params
      expect(response.status).to eq 422
    end

    it "[FAIL] Invalid jwt token" do
      put "/api/v1/users/profile", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No jwt token" do
      put "/api/v1/users/profile"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end
end
