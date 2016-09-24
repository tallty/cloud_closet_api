class UserInfosController < ApplicationController
  include ActionView::Layouts

  acts_as_token_authentication_handler_for User, except: [:check, :reset, :test] 

  before_action :set_user_info, only: [:show, :update]

  respond_to :json

  def index
    @user_infos = UserInfo.all
    respond_with @user_infos
  end

  def show
    respond_with @user_info
  end


  def update
    @user_info.update(user_info_params)
    respond_with(@user_info)
  end


  private
    def set_user_info
      @user_info = current_user.info
    end

    def user_info_params
      params[:user_info]
    end
end
