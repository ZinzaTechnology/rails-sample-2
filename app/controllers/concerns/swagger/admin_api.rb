module Swagger::AdminApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path "/admin/api/sign_in" do
      operation :post do
        key :summary, ""
        key :tags, ["Admin"]
        parameter do
          key :name, :admin
          key :in, :body
          schema do
            property :email do
              key :type, :string
              key :example, "test@zinza.com"
            end
            property :password do
              key :type, :string
              key :example, "123456"
            end
          end
        end
      end
    end

    swagger_path "/admin/api/admins" do
      operation :get do
        key :summary, ""
        key :tags, ["Admin (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :per_page
          key :in, :query
          key :type, :integer
        end
        parameter do
          key :name, :page
          key :in, :query
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/admins/{id}" do
      operation :get do
        key :summary, ""
        key :tags, ["Admin (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :id
          key :in, :path
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/admins" do
      operation :post do
        key :summary, ""
        key :tags, ["Admin (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :body
          key :in, :body
          schema do
            property :email do
              key :type, :string
              key :example, "test@zinza.com"
            end
            property :password do
              key :type, :string
              key :example, "123456"
            end
          end
        end
      end
    end

    swagger_path "/admin/api/admins/{id}" do
      operation :put do
        key :summary, ""
        key :tags, ["Admin (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :id
          key :in, :path
          key :type, :integer
        end
        parameter do
          key :name, :body
          key :in, :body
          schema do
            property :email do
              key :type, :string
              key :example, "test@zinza.com"
            end
            property :password do
              key :type, :string
              key :example, "123456"
            end
          end
        end
      end
    end

    swagger_path "/admin/api/admins/{id}" do
      operation :delete do
        key :summary, ""
        key :tags, ["Admin (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :id
          key :in, :path
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/sign_in" do
      operation :post do
        key :summary, ""
        key :tags, ["Admin"]
        parameter do
          key :name, :admin
          key :in, :body
          schema do
            property :email do
              key :type, :string
              key :example, "abc@gmail.com"
            end
            property :password do
              key :type, :string
              key :example, "123456"
            end
          end
        end
      end
    end

    # User
    swagger_path "/admin/api/users" do
      operation :get do
        key :summary, ""
        key :tags, ["Admin User (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :per_page
          key :in, :query
          key :type, :integer
        end
        parameter do
          key :name, :page
          key :in, :query
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/users/{id}" do
      operation :get do
        key :summary, ""
        key :tags, ["Admin User (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :id
          key :in, :path
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/users/{uid}/profile" do
      operation :get do
        key :summary, ""
        key :tags, ["Admin User (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :uid
          key :in, :path
          key :type, :integer
        end
      end
    end

    swagger_path "/admin/api/users" do
      operation :post do
        key :summary, ""
        key :tags, ["Admin User (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :body
          key :in, :body
          schema do
            property :name do
              key :type, :string
              key :example, "User Name"
            end
            property :phone_num do
              key :type, :string
              key :example, "0123456789"
            end
            property :zip_code do
              key :type, :string
              key :example, "10000"
            end
            property :prefecture do
              key :type, :string
              key :example, "Hanoi"
            end
            property :address do
              key :type, :string
              key :example, "Vietnam"
            end
            property :website_url do
              key :type, :string
              key :example, "https://zinza.example/"
            end
            property :description do
              key :type, :string
              key :example, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
            end
          end
        end
      end
    end

    swagger_path "/admin/api/users/{id}" do
      operation :put do
        key :summary, ""
        key :tags, ["Admin User (Required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :id
          key :in, :path
          key :type, :integer
        end
        parameter do
          key :name, :body
          key :in, :body
          schema do
            property :name do
              key :type, :string
              key :example, "User Name"
            end
            property :phone_num do
              key :type, :string
              key :example, "0123456789"
            end
            property :zip_code do
              key :type, :string
              key :example, "10000"
            end
            property :prefecture do
              key :type, :string
              key :example, "Hanoi"
            end
            property :address do
              key :type, :string
              key :example, "Vietnam"
            end
            property :website_url do
              key :type, :string
              key :example, "https://zinza.example/"
            end
            property :description do
              key :type, :string
              key :example, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
            end
          end
        end
      end
    end
  end
end
