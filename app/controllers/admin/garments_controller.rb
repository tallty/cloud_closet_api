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
    #更新时可不传图片
    @garment.update(cover_image_params)
    @garment.update(detail_image_params)
###多图时候？？？
    @garment.do_finish_storing #管理员入库衣服后 衣服状态改为 已入库

    @garment.set_put_in_time_and_expire_time(params[:store_month]) #设置 入库时间 与 过期时间

    @appointment = Appointment.find(params[:appointment_id])
    @appointment.do_stored_if_its_garments_are_all_stored

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
        :title, :row, :carbit, :place 
        )
    end

    def cover_image_params
      params.require(:garment).permit(
        cover_image_attributes: [:id, :photo, :_destroy]
        )
    end

    def detail_image_params
      params.require(:garment).permit(
        detail_images_attributes: [:id, :photo, :_destroy]
        )
    end

end
