require "rails_helper"

RSpec.describe "Admin::Api::AdminsController", type: :request do
  before do
    @admin = FactoryBot.create(:admin)
  end

  describe "GET: /admin/api/admins" do
    it "[SUCCESS] Valid JWT Token" do
      get "/admin/api/admins", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"admins\"")
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/admins", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/admins"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "GET: /admin/api/admins/{id}" do
    it "[SUCCESS] Valid JWT Token & ID" do
      get "/admin/api/admins/#{@admin.id}", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"admin\"")
      expect(response.body).to include(@admin.id.to_s)
    end

    it "[FAIL] Invalid ID" do
      get "/admin/api/admins/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      get "/admin/api/admins/#{@admin.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      get "/admin/api/admins/#{@admin.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "POST: /admin/api/admins" do
    it "[SUCCESS] Valid parameters" do
      admin1 = FactoryBot.build(:admin_with_updated_info)
      params = admin1.as_json
      post "/admin/api/admins", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.content_type).to eq("application/json")
      expect(response.body).to include("\"admin\"")
      expect(response.status).to eq 200
    end

    it "[FAIL] Not unique email" do
      FactoryBot.create(:admin, email: "admin@example.com", password: "123456")
      admin2 = FactoryBot.build(:admin_with_updated_info)
      params = admin2.as_json
      post "/admin/api/admins", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 422
    end

    it "[FAIL] Invalid JWT Token" do
      post "/admin/api/admins", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      post "/admin/api/admins"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "PUT: /admin/api/admins/{id}" do
    it "[SUCCESS] Valid parameters" do
      @other_admin = FactoryBot.create(:admin, email: "other_admin@example.com", password: "123456")
      admin1 = FactoryBot.build(:admin_with_updated_info)
      params = admin1.as_json
      put "/admin/api/admins/#{@other_admin.id}", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.status).to eq 200
      expect(response.body).to include("\"admin\"")
      expect(response.body).to include(@other_admin.id.to_s)
    end

    it "[FAIL] Not unique email" do
      FactoryBot.create(:admin, email: "admin@example.com", password: "123456")
      admin2 = FactoryBot.build(:admin_with_updated_info)
      params = admin2.as_json
      put "/admin/api/admins/#{@admin.id}", headers: authenticated_header_for_admin(@admin), params: params
      expect(response.status).to eq 422
    end

    it "[FAIL] Invalid ID" do
      put "/admin/api/admins/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      put "/admin/api/admins/#{@admin.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      put "/admin/api/admins/#{@admin.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end

  describe "DELETE: /admin/api/admins/{id}" do
    it "[SUCCESS] Valid parameters" do
      delete "/admin/api/admins/#{@admin.id}", headers: authenticated_header_for_admin(@admin)
      expect(response.status).to eq 204
    end

    it "[FAIL] Invalid ID" do
      delete "/admin/api/admins/-1", headers: authenticated_header_for_admin(@admin)
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 404
    end

    it "[FAIL] Invalid JWT Token" do
      delete "/admin/api/admins/#{@admin.id}", headers: { 'Authorization': "Bearer wrong_token" }
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end

    it "[FAIL] No JWT token" do
      delete "/admin/api/admins/#{@admin.id}"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 401
    end
  end
end
