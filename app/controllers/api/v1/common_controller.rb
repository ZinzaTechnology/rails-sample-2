class Api::V1::CommonController < Api::BaseController
  def summary
    json_response(user_count: User.count)
  end
end
