class UserInfosController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User, except: [:check, :reset] 

  before_action :set_user_info, only: [:show, :update, :test]

  respond_to :json

  def show
    respond_with @user_info
  end

  def update
    @user_info.update(user_info_params)
    respond_with @user_info, template: "user_infos/show", status: 201
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
end
