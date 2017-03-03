class ExhibitionChestsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_exhibition_chest, only: [ :move_garment, :the_same_store_method, :show, :update, :destroy]

  respond_to :json

  def index
    @exhibition_chests = current_user.exhibition_chests
    respond_with(@exhibition_chests)
  end

  def show
    p '----'
    p @garments = @exhibition_chest.garments.stored
    respond_with @exhibition_chest, template: 'exhibition_chests/show'
  end

  # def create
  #   @exhibition_chest = current_user.exhibition_chests.new(exhibition_chest_params)
  #   @exhibition_chest.save
  #   respond_with(@exhibition_chest)
  # end

  def update
    @exhibition_chest.update(exhibition_chest_params)
    respond_with(@exhibition_chest)
  end

  def the_same_store_method
    @exhibition_chests = current_user.exhibition_chests.store_method_is(@exhibition_chest.store_method)
    respond_with @exhibition_chests, template: 'exhibition_chests/index'
  end

  def move_garment # garment_ids to_exhibition_chest_id
    @exhibition_chest.where(id: params[:garment_ids]).each do |garment|
      garment.exhibition_chest_id = params[:to_exhibition_chest_id]
      garment.save
    end
    respond_with @exhibition_chest, template: 'exhibition_chests/show'
  end

  # def destroy
  #   @exhibition_chest.destroy
  #   respond_with(@exhibition_chest)
  # end

  private
    def set_exhibition_chest
      @exhibition_chest = current_user.exhibition_chests.find(params[:id])
    end

    def exhibition_chest_params
      params[:exhibition_chest]
    end
end
