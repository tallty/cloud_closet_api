class Admin::ServiceOrdersController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

	before_action :set_service_order, only: [:show, :update, :destroy]

  respond_to :json

  def index
    if params[:user_id]
      user = User.find_by_id(params[:user_id])
      user ? @service_orders = user.service_orders : ( head 404; return)
    else
      @service_orders = ServiceOrder.all
    end
    respond_with @service_orders, template: 'service_orders/index'
  end

  def show
    respond_with @service_order, template: 'service_orders/show'
  end

  def create
    user = User.find_by_id(params[:user_id])
    if user
      @service_order = ServiceOrder.create_by_admin user, service_order_params, service_order_group_params
      respond_with @service_order, template: 'service_orders/show', status: 201
    else
      head 404
    end
  rescue => error
    render json: { error: error }, status: 422
  end

  def destroy
    @service_order.destroy
    render body: nil, status: 204
  end

  private
    def set_service_order
      @service_order = PublicMsg.find(params[:id])
    end

    def service_order_params
      params.require(:service_order).permit(
          :remark, :care_cost, :service_cost, :operation
        ) if params[:service_order]
    end
    
    def service_order_group_params 
      params.require(:service_order_groups).permit(
        price_groups: [
          :price_system_id, :count, :store_month
        ]
      ) if params[:service_order_groups]
    end
end