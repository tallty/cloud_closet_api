class DeliveryOrdersController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_delivery_order, only: [:show, :update]

  respond_to :json

  def index # params[:state]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    # @delivery_orders = current_user.delivery_orders&.send(params[:state] || :all)
    @delivery_orders =  DeliveryOrder.all
    respond_with(@delivery_orders)
  end

  def show
    respond_with(@delivery_order)
  end

  def create # params[:garment_ids]
  	@delivery_order = current_user.delivery_orders.create!(delivery_order_params)
    post_one
  end

  def update
    @delivery_order.update!(delivery_order_psarams)  
    post_one
  end

  def destroy
    @delivery_order.destroy!

    head 204
  end

  def pay
    @delivery_order.pay!
    post_one
  end


  private
    def set_delivery_order
      @delivery_order = current_user.delivery_orders.find_by_id(params[:id])
      head 404 unless @delivery_order
    end

    def post_one
      respond_with @delivery_order, template: 'delivery_orders/show', status: 201
    # rescue => @error
    #   respond_with @error, template: 'error', status: 422
    end

    def delivery_order_params
      params.require(:delivery_order).permit(
          :address, :name, :phone, :delivery_time, 
          :delivery_method, :remark, :delivery_cost,
          :service_cost, :garment_ids
        )
    end



end