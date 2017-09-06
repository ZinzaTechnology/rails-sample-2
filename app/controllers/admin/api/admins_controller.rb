class Admin::Api::AdminsController < Admin::ApiBaseController
  before_action :authenticate_request!
  before_action :load_admin, only: %i[show update destroy]

  def index
    set_paginate_params

    @admins = Admin.select(Admin.column_names - %w[password created_at updated_at]).page(@page).per(@record_per_page)
    total_pages = @admins.total_pages

    json_response(admins: @admins, current_page: @page, total_pages: total_pages)
  end

  def show
    json_response(admin: @admin.as_public_json)
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.save!
    json_response(admin: @admin.as_public_json)
  end

  def update
    @admin.update!(admin_params)
    json_response(admin: @admin.as_public_json)
  end

  def destroy
    @admin.destroy
    head :no_content
  end

  private

  def load_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.permit(:email, :password)
  end
end
