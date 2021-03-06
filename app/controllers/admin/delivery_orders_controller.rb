class Admin::DeliveryOrdersController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

  before_action :set_delivery_order, only: [:show, :cancel, :send_out, :destroy]

  respond_to :json

  def index # params[:state]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @need_garment_info = params[:need_garment_info]
    delivery_orders = User.find_by_id(params[:user_id]).try(:delivery_orders) || DeliveryOrder.all
    @delivery_orders = delivery_orders&.send(params[:state] || :all).paginate(page: page, per_page: per_page)
    respond_with @delivery_orders, template: 'delivery_orders/index', status: 200
  end

  def show
    respond_with @delivery_order, template: 'delivery_orders/show', status: 200
  end

  def cancel
    @delivery_order.canceled_by_admin!
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    raise MyError.new(@error)
  end

  def send_out
    @delivery_order.admin_send_it_out!
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    raise MyError.new(@error)
  end

  def destroy
    @delivery_order.soft_delete
    head 204
  end

  private
    def set_delivery_order
      @delivery_order = DeliveryOrder.find_by_id(params[:id])
      head 404 unless @delivery_order
    end
end