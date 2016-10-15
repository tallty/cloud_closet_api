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
    respond_with(@admin_garment)
  end

  # def create
  #   @admin_garment = Admin::Garment.new(admin_garment_params)
  #   @admin_garment.save
  #   respond_with(@admin_garment)
  # end

  def update
    @admin_garment.update(admin_garment_params)
    respond_with(@admin_garment)
  end

  # def destroy
  #   @admin_garment.destroy
  #   respond_with(@admin_garment)
  # end

  private
    def set_admin_garment
      @admin_garment = Garment.find(params[:id])
    end

    def admin_garment_params
      params[:admin_garment]
    end
end
