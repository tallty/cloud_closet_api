class DeliveryOrdersController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_delivery_order, only: [:show, :update, :destroy, :pay, :get_home]

  respond_to :json

  def index # params[:state]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @need_garment_info = params[:need_garment_info]
    @delivery_orders = current_user.delivery_orders&.send(params[:state] || :all).paginate(page: page, per_page: per_page).order('delivery_time DESC')
    respond_with(@delivery_orders)
  end

  def show
    respond_with(@delivery_order)
  end

  def create # params[:garment_ids]
  	@delivery_order = current_user.delivery_orders.create!(delivery_order_params)
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def update
    raise '只可修改未支付订单' unless @delivery_order.unpaid?
    @delivery_order.update!(delivery_order_params)  
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def destroy
    raise '只可删除修改未支付订单' unless @delivery_order.unpaid?
    @delivery_order.destroy!
    head 204
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def pay
    @delivery_order.pay!
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def get_home
    @delivery_order.get_home!
    respond_with @delivery_order, template: 'delivery_orders/show', status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end


  private
    def set_delivery_order
      @delivery_order = current_user.delivery_orders.find_by_id(params[:id])
      head 404 unless @delivery_order
    end

    def delivery_order_params
      garment_ids = params[:delivery_order]&.[](:garment_ids)
      params.require(:delivery_order).permit(
          :address, 
          :name, :phone, :delivery_time, 
          :delivery_method, :remark, :delivery_cost,
          :service_cost
        ).merge( garment_ids.is_a?(Array) ?
          { garment_ids:  garment_ids } :
          {}
        )
    end



end