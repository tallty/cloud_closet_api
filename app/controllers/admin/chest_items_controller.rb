class Admin::ChestItemsController < ApplicationController
  acts_as_token_authentication_handler_for Admin
  before_action :set_admin_chest_item, only: [:show, :destroy]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 15
    @admin_chest_items = ChestItem.all.paginate(page: page, per_page: per_page)
    respond_with(@admin_chest_items)
  end

  def show
    respond_with(@admin_chest_item)
  end

  def create
    @admin_chest_item = ChestItem.new(admin_chest_item_params)
    @admin_chest_item.save
    respond_with(@admin_chest_item)
  end

  def destroy
    @admin_chest_item.destroy
    respond_with(@admin_chest_item)
  end

  private
    def set_admin_chest_item
      @admin_chest_item = ChestItem.find(params[:id])
    end

    def admin_chest_item_params
      params.require(:chest_item).permit(:chest_id, :garment_id)
    end
end
