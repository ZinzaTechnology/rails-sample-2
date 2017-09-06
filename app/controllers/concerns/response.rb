module Response
  def json_response(data = {}, status = :ok)
    render json: data.merge(status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status]), status: status
  end

  def set_paginate_params
    @record_per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end
end
