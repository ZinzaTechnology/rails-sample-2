module Swagger::UserApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path "/api/v1/users" do
      operation :get do
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        key :summary, "User list"
        key :tags, ["User"]
        parameter do
          key :name, :date
          key :type, :string
          key :in, :query
        end
        parameter do
          key :name, :address_lat
          key :type, :string
          key :in, :query
        end
        parameter do
          key :name, :address_long
          key :type, :string
          key :in, :query
        end
      end
    end

    swagger_path "/api/v1/users/{id}" do
      operation :get do
        key :summary, "User detail"
        key :tags, ["User"]
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

    swagger_path "/api/v1/users/profile" do
      operation :get do
        key :summary, "Logged in user profile"
        key :tags, ["User (required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
      end
    end

    swagger_path "/api/v1/users/profile" do
      operation :put do
        key :summary, "Logged in user profile: update"
        key :tags, ["User (required login)"]
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

    swagger_path "/api/v1/users/notifications" do
      operation :get do
        key :summary, "Notification list"
        key :tags, ["User Notification (required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
      end
    end

    swagger_path "/api/v1/users/notifications" do
      operation :get do
        key :summary, "User notification"
        key :tags, ["User Notification (required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
      end
    end

    swagger_path "/api/v1/users/notifications/unread_count" do
      operation :get do
        key :summary, "User unread notification count"
        key :tags, ["User Notification (required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
      end
    end

    swagger_path "/api/v1/users/notifications/{notification_id}/mark_as_read" do
      operation :put do
        key :summary, "User mask_as_read notification"
        key :tags, ["User Notification (required login)"]
        parameter do
          key :name, :Authorization
          key :in, :header
          key :type, :string
        end
        parameter do
          key :name, :notification_id
          key :in, :path
          key :type, :integer
        end
      end
    end
  end
end
