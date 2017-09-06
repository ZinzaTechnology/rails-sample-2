require "rails_helper"

RSpec.describe "Api::ApiDocsController", type: :request do
  describe "GET: /api/api_docs" do
    it "[SUCCESS] Valid parameters" do
      get "/api/api_docs"
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq 200
      expect(response.body).to include("\"info\"")
      expect(response.body).to include("\"paths\"")
    end
  end
end
