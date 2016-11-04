class AddressesController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_address, only: [:show, :update, :destroy, :set_default]
  before_action :insure_default_address_exist, except: [:create]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @addresses = current_user.user_info.addresses.paginate(page: page, per_page: per_page)
    respond_with(@addresses)
  end

  def show
    respond_with(@address)
  end

  def create
    @address = current_user.user_info.addresses.build(address_params)
    @address.save
    respond_with @address, template: "addresses/show", status: 201
  end

  def update
    @address.update(address_params)
    respond_with @address, template: "addresses/show", status: 201
  end

  def destroy
    @address.destroy
    respond_with(@address)
  end

  def set_default
    current_user.user_info.default_address_id = @address.id
    current_user.user_info.save
   
    respond_with  @address, template: "addresses/show", status: 201
  end

  private
    def set_address
      @address = current_user.user_info.addresses.find(params[:id])
    end

    def address_params
      params.require(:address).permit(:name, :address_detail, :phone)
    end

    def insure_default_address_exist
      #定义变量 并且保证存在
      current_user.user_info.refresh_default_address      
    end

end
