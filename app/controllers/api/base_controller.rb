class Api::BaseController < ActionController::Base
  include BulletHelper
  include Response
  include ExceptionHandler

  before_action :store_user_location!, if: :storable_location?

  protect_from_forgery unless: -> { request.format.json? }

  responders :flash
  respond_to :html

  attr_reader :current_user

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def authenticate_user!
    return json_response({ message: "Not Authenticated" }, :unauthorized) unless user_id_in_token?

    @current_user = User.find_or_initialize_by(uid: auth_user["user_id"], email: auth_user["email"])
    @current_user.update(name: auth_user["name"]) if @current_user[:name].blank?
  rescue JWT::VerificationError, JWT::DecodeError, StandardError => error
    json_response({ messages: ["Not Authenticated", error.message] }, :unauthorized)
  end

  def http_token
    @http_token ||= request.headers["Authorization"].split(" ").last if request.headers["Authorization"].present?
  end

  def auth_token
    verifier = FirebaseIDTokenVerifier.new(ENV["FIREBASE_PROJECT_ID"])
    @auth_token ||= verifier.decode(http_token, nil)
  end

  def user_id_in_token?
    http_token && auth_token && auth_user && auth_user["user_id"]
  end

  def auth_user
    auth_token[0]
  end
end
