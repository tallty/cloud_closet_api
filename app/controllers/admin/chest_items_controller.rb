class Admin::ChestItemsController < ApplicationController
  before_action :set_admin_chest_item, only: [:show, :destroy]

  respond_to :json

  def index
    @admin_chest_items = Admin::ChestItem.all
    respond_with(@admin_chest_items)
  end

  def show
    respond_with(@admin_chest_item)
  end

  def create
    @admin_chest_item = Admin::ChestItem.new(admin_chest_item_params)
    @admin_chest_item.save
    respond_with(@admin_chest_item)
  end

  def destroy
    @admin_chest_item.destroy
    respond_with(@admin_chest_item)
  end

  private
    def set_admin_chest_item
      @admin_chest_item = Admin::ChestItem.find(params[:id])
    end

    def admin_chest_item_params
      params[:admin_chest_item]
    end
end
