class Admin::ExhibitionChestsController < ApplicationController
  before_action :set_exhibition_chest, only: [:release, :show, :update, :destroy]
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin
  respond_to :json

  def index
    @exhibition_chests = Admin::ExhibitionChest.all
    respond_with(@exhibition_chests)
  end

  def show
    respond_with(@exhibition_chest)
  end

  # def create
  #   @exhibition_chest = Admin::ExhibitionChest.new(exhibition_chest_params)
  #   @exhibition_chest.save
  #   respond_with(@exhibition_chest)
  # end

  def release
    @exhibition_chest.release!
    respond_with @exhibition_chest, template: 'exhibition_chests/exhibition_chest', status: 201
  rescue

  end

  def update
    @exhibition_chest.update(exhibition_chest_params)
    respond_with(@exhibition_chest)
  end

  def destroy
    @exhibition_chest.destroy
    respond_with(@exhibition_chest)
  end

  private
    def set_exhibition_chest
      @exhibition_chest = Admin::ExhibitionChest.find(params[:id])
    end

    def exhibition_chest_params
      params[:exhibition_chest]
    end
end
