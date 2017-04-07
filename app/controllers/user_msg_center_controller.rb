class UserMsgCenterController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  respond_to :json

  def user_msg_center
    @user_msgs = current_user.user_msgs
    @public_msgs = PublicMsg.all
    respond_with @user_msgs, template: 'user_msg_center'
  end
end
