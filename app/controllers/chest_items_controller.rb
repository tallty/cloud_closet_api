class ChestItemsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_chest_item, only: [:destroy]

  respond_to :json

  def index
    @chest = current_user.chests.find(params[:chest_id])
    page = params[:page] || 1
    per_page = params[:per_page] || 15
    @chest_items = @chest.items.paginate(page: page, per_page: per_page)
    respond_with(@chest_items)
  end

  # def show
  #   respond_with(@chest_item)
  # end

  def create
    @chest = current_user.chests.find(params[:chest_id])
    @chest_item = @chest.items.build(chest_item_params)
    @chest_item.save
    respond_with(@chest_item)
  end

  def destroy
    @chest_item.destroy
    respond_with(@chest_item)
  end

  private
    def set_chest_item
      @chest_item = ChestItem.find(params[:id])
    end

    def chest_item_params
      params.require(:chest_item).permit(:chest_id, :garment_id)
    end
end
