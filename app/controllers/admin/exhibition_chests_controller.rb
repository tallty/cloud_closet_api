class Admin::ExhibitionChestsController < ApplicationController
  before_action :set_admin_exhibition_chest, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @admin_exhibition_chests = Admin::ExhibitionChest.all
    respond_with(@admin_exhibition_chests)
  end

  def show
    respond_with(@admin_exhibition_chest)
  end

  def create
    @admin_exhibition_chest = Admin::ExhibitionChest.new(admin_exhibition_chest_params)
    @admin_exhibition_chest.save
    respond_with(@admin_exhibition_chest)
  end

  def update
    @admin_exhibition_chest.update(admin_exhibition_chest_params)
    respond_with(@admin_exhibition_chest)
  end

  def destroy
    @admin_exhibition_chest.destroy
    respond_with(@admin_exhibition_chest)
  end

  private
    def set_admin_exhibition_chest
      @admin_exhibition_chest = Admin::ExhibitionChest.find(params[:id])
    end

    def admin_exhibition_chest_params
      params[:admin_exhibition_chest]
    end
end
