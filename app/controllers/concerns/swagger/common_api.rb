module Swagger::CommonApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path "/api/v1/contacts" do
      operation :post do
        key :summary, "Contact form"
        key :tags, ["Common"]
        parameter do
          key :name, :body
          key :in, :body
          schema do
            property :name do
              key :type, :string
              key :example, "Random Name"
            end
            property :email do
              key :type, :string
              key :example, "random-user@random-domain.com"
            end
            property :content do
              key :type, :string
              key :example, "Contact content: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            end
          end
        end
      end
    end

    swagger_path "/api/v1/summary" do
      operation :get do
        key :summary, "Summary: user count"
        key :tags, ["Common"]
      end
    end
  end
end
