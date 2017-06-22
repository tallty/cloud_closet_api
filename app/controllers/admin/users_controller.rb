class Admin::UsersController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

  before_action :set_user, only: [:show]

  respond_to :json

  def index # params[:state]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @users = User.paginate(page: page, per_page: per_page)
    respond_with @users, template: 'admin/users/index', status: 200
  end

  private
    def set_user
      @user = User.find_by_id(params[:id])
      head 404 unless @user
    end
end