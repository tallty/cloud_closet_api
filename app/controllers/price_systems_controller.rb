class PriceSystemsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_price_system, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @price_systems = PriceSystem.chests
    respond_with(@price_systems)
  end

  def show
    respond_with(@price_system)
  end

  # def create
  #   @price_system = PriceSystem.new(price_system_params)
  #   @price_system.save
  #   respond_with(@price_system)
  # end

  # def update
  #   @price_system.update(price_system_params)
  #   respond_with(@price_system)
  # end

  # def destroy
  #   @price_system.destroy
  #   respond_with(@price_system)
  # end

  private
    def set_price_system
      @price_system = PriceSystem.chests.find(params[:id])
    end

    def price_system_params
      params[:price_system]
    end
end
