class Api::ApiDocsController < Api::BaseController
  include Swagger::Blocks

  include Swagger::AdminApi
  include Swagger::UserApi
  include Swagger::CommonApi

  swagger_root do
    key :swagger, "2.0"
    info do
      key :version, "1.0"
      key :title, "ZINZA"
      key :description, "API DOCUMENT"
    end
  end

  SWAGGERED_CLASSES = [
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
