class Admin:UsersController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

  before_action :set_delivery_order, only: [:show]

  respond_to :json

  def index # params[:state]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @need_garment_info = params[:need_garment_info]
    @delivery_orders = DeliveryOrder&.send(params[:state] || :all).paginate(page: page, per_page: per_page)
    respond_with @delivery_orders, template: 'admin/users/index', status: 200
  end

  def show
    respond_with @delivery_order, template: 'admin/users/show', status: 200
  end

  private
    def set_delivery_order
      @delivery_order = DeliveryOrder.find_by_id(params[:id])
      head 404 unless @delivery_order
    end
end