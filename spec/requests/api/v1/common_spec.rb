require "rails_helper"

RSpec.describe "Api::V1::CommonController", type: :request do
  describe "GET: /api/v1/summary" do
    it "[SUCCESS] Valid parameters" do
      get "/api/v1/summary"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"user_count\"")
    end
  end
end
