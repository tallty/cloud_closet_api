class UserInfosController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User, except: [:check_openid, :check, :reset] 

  before_action :set_user_info, only: [:show, :update, :test, :bind]

  respond_to :json

  def show
    respond_with @user_info
  end

  def update
    @user_info.update(user_info_params)
    respond_with @user_info, template: "user_infos/show", status: 201
  end

  def bind
    current_user.bind_openid(bind_params[:openid])
    respond_with @user_info, template: "user_infos/show", status: 201
  end

  def check_openid
    @openid = bind_params[:openid]
    @user = User.find_by openid: @openid
    if @openid.present? && @user.present?
      respond_with @user
    else
      respond_with @user, status: 404
    end
  end


  private
    def set_user_info
      @user_info = current_user.info
    end

    def user_info_params
      params.require(:user_info).permit(
        :nickname, :mail,
        avatar_attributes: [:id, :photo, :_destroy]
        )
    end

    def bind_params
      params.require(:user).permit(
        :openid
        )
    end
end
