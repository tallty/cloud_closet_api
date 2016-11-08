class Work::PriceSystemsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_price_system, only: [:show]

  respond_to :json

  def index
    @price_systems = PriceSystem.all
    respond_with @price_systems, template: "price_systems/index", status: 200
  end

  def show
    respond_with @price_system, template: "price_systems/show", status: 200
  end

  # def create
  #   @price_system = PriceSystem.new(price_system_params)
  #   @price_system.save
  #   respond_with @price_system, template: "price_systems/show", status: 201
  # end

  # def update
  #   @price_system.update(price_system_params)
  #   respond_with @price_system, template: "price_systems/show", status: 201
  # end

  # def destroy
  #   @price_system.destroy
  #   respond_with @price_system, template: "price_systems/show", status: 204
  # end

  private
    def set_price_system
      @price_system = PriceSystem.find(params[:id])
    end

    # def price_system_params
    #   params.require(:price_system).permit(:name, :season, :price, icon_images_attributes: [:id, :photo, :_destroy])
    # end
end
