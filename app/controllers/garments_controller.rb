class GarmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_garment, only: [:show]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @garments = current_user.garments.paginate(page: page, per_page: per_page)
    respond_with(@garments)
  end

  def show
    respond_with(@garment)
  end

  # def create
  #   @garment = Garment.new(garment_params)
  #   @garment.save
  #   respond_with(@garment)
  # end

  # def update
  #   @garment.update(garment_params)
  #   respond_with(@garment)
  # end

  # def destroy
  #   @garment.destroy
  #   respond_with(@garment)
  # end

  private
    def set_garment
      @garment = current_user.garments.find(params[:id])
    end
end
