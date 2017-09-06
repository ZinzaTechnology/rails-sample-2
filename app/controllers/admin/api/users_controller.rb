class Admin::Api::UsersController < Admin::ApiBaseController
  before_action :authenticate_request!
  before_action :load_user, only: %i[show update destroy]

  def index
    set_paginate_params

    users = User.order(updated_at: :desc).page(@page).per(@record_per_page)
    total_pages = users.total_pages

    json_response(users: users, current_page: @page, total_pages: total_pages)
  end

  def show
    image_info = @user.firebase_image(Firestore::IMAGE_TYPE[:profile])
    json_response(user: @user.as_public_json, image_info: image_info)
  end

  def create
    @user = User.new(user_params)
    @user.save!
    json_response(user: @user.as_public_json)
  end

  def update
    @user.update!(user_params)
    json_response(user: @user.as_public_json)
  end

  def destroy
    @user.destroy_user
    head :no_content
  end

  def profile
    user = User.find_by!(uid: params[:id])

    json_response(user: user.as_public_json)
  end

  def update_email
    uid = params[:id]
    object_params = { email: params[:email] }
    user = User.find_by!(uid: uid)

    user.update_email(object_params)
    json_response
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:address, :name, :phone_num, :prefecture, :zip_code, :description)
  end
end
