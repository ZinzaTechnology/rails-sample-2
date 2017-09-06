class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_user!, only: %i[profile_show profile_update destroy update_email]
  before_action :load_user, only: %i[show]

  def index
    @users_on_date = WorktimeSheet.user_work_at_date(params[:date])

    user_without_authorization
    json_response(users: @users)
  end

  def show
    profile_image = @user.firebase_image(Firestore::IMAGE_TYPE[:profile])
    user = @user.as_public_json.merge(profile_image: profile_image)
    json_response(user: user)
  end

  def profile_show
    json_response(user: current_user)
  end

  def profile_update
    current_user.update!(user_params)
    json_response
  end

  def destroy
    current_user.update!(leave_service: true)
    json_response
  end

  def update_email
    object_params = { email: params[:email] }
    current_user.update_email(object_params)
    json_response
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:address, :name, :phone_num, :prefecture, :zip_code, :description)
  end

  def user_without_authorization
    @users = if params[:address_lat].present? && params[:address_long].present?
      near_users = User.using_service.near([params[:address_lat], params[:address_long]], 30)
      @users_on_date.select { |user| user["id"].in?(near_users.map(&:id)) && user["uid"] != current_user.uid }
    else
      @users_on_date
    end
  end
end
