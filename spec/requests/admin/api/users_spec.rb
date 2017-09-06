require "rails_helper"

RSpec.describe "Admin::Api::UsersController", type: :request do
  before do
    @admin = FactoryBot.create(:admin)
    @user = FactoryBot.create(:user)
  end

  describe "GET: /admin/api/users" do
    it "[SUCCESS] Valid JWT Token" do
      get "/admin/api/users", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"users\"")
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/users", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/users"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "GET: /admin/api/users/{id}" do
    it "[SUCCESS] Valid JWT Token & ID" do
      get "/admin/api/users/#{@user.id}", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"user\"")
      expect(response.body).to include(@user.id.to_s)
    end

    it "[FAIL] Invalid ID" do
      get "/admin/api/users/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/users/#{@user.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/users/#{@user.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "POST: /admin/api/users" do
    it "[SUCCESS] Valid parameters" do
      user1 = FactoryBot.build(:user)
      params = user1.as_json
      params[:desired_worktimes] = [{ date: "02-21-2019", from: "10:00:00", to: "12:00:00" }, { date: "02-22-2019", from: "8:00:00", to: "10:00:00" }]
      post "/admin/api/users", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.content_type).to eq("application/json")
      expect(response.body).to include("\"user\"")
      expect(response.status).to eq 200

      # Check user info in database
      last_user = User.last
      expect(last_user.email).to eq params["email"]
      expect(last_user.desired_worktimes.count).to eq 2
    end

    it "[FAIL] Invalid JWT Token" do
      post "/admin/api/users", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      post "/admin/api/users"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "PUT: /admin/api/users/{id}" do
    it "[SUCCESS] Valid parameters" do
      params = FactoryBot.build(:user).as_json
      put "/admin/api/users/#{@user.id}", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.status).to eq 200
      expect(response.body).to include("\"user\"")
      expect(response.body).to include(@user.id.to_s)

      # Check user info in database
      user = User.find(@user.id)
      expect(user.email).to eq params["email"]
    end

    it "[FAIL] Invalid parameters" do
      user2 = FactoryBot.build(:user_with_updated_info)
      params = user2.as_json
      params["website_url"] = "zinza.com.vn"
      params["reference_url"] = "zinza.com.vn"
      put "/admin/api/users/#{@user.id}", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.status).to eq 422
    end

    it "[FAIL] Invalid ID" do
      put "/admin/api/users/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      put "/admin/api/users/#{@user.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      put "/admin/api/users/#{@user.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "DELETE: /admin/api/users/{id}" do
    it "[SUCCESS] Valid parameters" do
      delete "/admin/api/users/#{@user.id}", headers: authenticated_header_for_admin(@admin)
      expect(response.status).to eq 204
    end

    it "[FAIL] Invalid ID" do
      delete "/admin/api/users/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      delete "/admin/api/users/#{@user.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      delete "/admin/api/users/#{@user.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "GET: /admin/api/users/{id}/reviews" do
    it "[SUCCESS] Valid JWT Token & ID" do
      get "/admin/api/users/#{@user.id}/reviews", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"reviews\"")
      expect(response.body).to include("\"current_page\"")
      expect(response.body).to include("\"total_pages\"")
    end

    it "[FAIL] Invalid ID" do
      get "/admin/api/users/-1/reviews", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/users/#{@user.id}/reviews", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/users/#{@user.id}/reviews"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "GET: /admin/api/users/{uid}/profile" do
    it "[SUCCESS] Valid JWT Token & UID " do
      get "/admin/api/users/#{@user.uid}/profile", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"user\"")
    end

    it "[FAIL] Valid JWT Token & Invalid UID " do
      @invalid_uid = "#{@user.uid}test"
      get "/admin/api/users/#{@invalid_uid}/profile", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/users/#{@user.uid}/profile", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/users/#{@user.uid}/profile"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end
end
