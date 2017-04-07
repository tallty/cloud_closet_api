class PublicMsgsController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

	before_action :set_public_msg, only: [:show]

  respond_to :json

  def index
    @public_msgs = PublicMsg.all
    respond_with @public_msgs, template: 'public_msgs/index'
  end

  def show
    respond_with @public_msg, template: 'public_msgs/show'
  end

  private
    def set_public_msg
      @public_msg = PublicMsg.find(params[:id])
    end
end