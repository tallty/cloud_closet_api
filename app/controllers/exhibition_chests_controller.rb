class ExhibitionChestsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_exhibition_chest, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @exhibition_chests = current_user.exhibition_chests
    respond_with(@exhibition_chests)
  end

  def show
    respond_with(@exhibition_chest)
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
