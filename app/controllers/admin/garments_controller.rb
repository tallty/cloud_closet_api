class Admin::GarmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin 

  before_action :set_admin_garment, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @appointment_item_group = AppointmentItemGroup.find(params[:appointment_item_group_id])
    @admin_garments = @appointment_item_group.garments
    respond_with(@admin_garments)
  end

  def show
    respond_with @garment, template: "garments/show"
  end

  # def create
  #   @admin_garment = Admin::Garment.new(admin_garment_params)
  #   @admin_garment.save
  #   respond_with(@admin_garment)
  # end

  def update
    @garment.update(garment_params)
    respond_with @garment, template: "garments/show", status: 201
  end

  # def destroy
  #   @admin_garment.destroy
  #   respond_with(@admin_garment)
  # end

  private
    def set_admin_garment
      @garment = Garment.find(params[:id])
    end

    def garment_params
      params.require(:garment).permit(
        :title, :row, :carbit, :place, 
        cover_image_attributes: [:id, :photo, :_destroy],
        detail_images_attributes: [:id, :photo, :_destroy]
        )
    end
end
