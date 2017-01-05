class ChestsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_chest, only: [:show, :destroy]

  respond_to :json

  def index
    @chests = current_user.chests
    respond_with(@chests)
  end

  def show
    respond_with(@chest)
  end

  def destroy
    @chest.destroy
    respond_with(@chest)
  end

  private
    def set_chest
      @chest = Chest.find(params[:id])
    end
end
