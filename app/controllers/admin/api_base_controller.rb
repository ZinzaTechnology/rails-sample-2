class Admin::ApiBaseController < ActionController::Base
  include BulletHelper
  include Response
  include ExceptionHandler

  private

  def authenticate_request!
    return render json: { errors: ["Not Authenticated"] }, status: :unauthorized unless admin_id_in_token?

    @current_admin = Admin.find(auth_token["admin_id"])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ["Not Authenticated"] }, status: :unauthorized
  end

  def http_token
    @http_token ||= request.headers["Authorization"].split(" ").last if request.headers["Authorization"].present?
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def admin_id_in_token?
    http_token && auth_token && auth_token["admin_id"]
  end
end
