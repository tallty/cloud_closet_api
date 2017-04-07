class Admin::PublicMsgsController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

	before_action :set_public_msg, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @public_msgs = PublicMsg.all
    respond_with @public_msgs, template: 'public_msgs/index'
  end

  def show
    respond_with @public_msg, template: 'public_msgs/show'
  end

  def create
    @public_msg = PublicMsg.new(public_msg_params)
    @public_msg.save
    respond_with @public_msg, template: 'public_msgs/show', status: 201
  end

  def update
    @public_msg.update(public_msg_params)
    respond_with @public_msg, template: 'public_msgs/show', status: 201
  end

  def destroy
    @public_msg.destroy
    render body: nil, status: 204
  end

  private
    def set_public_msg
      @public_msg = PublicMsg.find(params[:id])
    end

    def public_msg_params
      params.require(:public_msg).permit(
      		:title, :abstract, :content
      	)
    end
end