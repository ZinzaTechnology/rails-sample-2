class Api::V1::Users::CommentsController < Api::BaseController
  before_action :authenticate_user!

  def create
    current_user.comments.create!(comment_params)
    json_response
  end

  private

  def comment_params
    params.permit(:post_id, :content)
  end
end
