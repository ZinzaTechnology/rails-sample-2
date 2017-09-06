class Admin::Api::SessionsController < ApplicationController
  def create
    admin = Admin.find_for_database_authentication(email: admin_params[:email])
    if admin&.valid_password?(admin_params[:password])
      render json: payload(admin)
    else
      render json: { errors: "Invalid Email or password" }, status: :unauthorized
    end
  end

  private

  def payload(admin)
    return nil unless admin.id

    {
      auth_token: JsonWebToken.encode(admin_id: admin.id),
      email: admin.email
    }
  end

  def admin_params
    params.permit(:email, :password)
  end
end
