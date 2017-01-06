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
    if @chest.items.nil?
      @chest.destroy
      respond_with(@chest)  
    else
      @error = "衣橱不为空，所以不能移除衣橱 ！"
      respond_with(@error, template: "error", status: 201)
    end
  end

  private
    def set_chest
      @chest = Chest.find(params[:id])
    end
end
