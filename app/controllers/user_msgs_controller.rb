class UserMsgsController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_user_msg, only: [:show]

  respond_to :json

  def index
    @user_msgs = current_user.user_msgs
    respond_with @user_msgs
  end

  def show
    respond_with(@user_msg)
  end

  private
    def set_user_msg
      @user_msg = current_user.user_msgs.find(params[:id])
    end
end
