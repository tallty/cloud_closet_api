class Admin::GarmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin 

  before_action :set_admin_garment, only: [:show, :destroy, :delete_detail]

  respond_to :json

  def index
    @garments = ExhibitionChest.find(params[:exhibition_chest_id]).garments
    respond_with @garments, template: 'garments/index'
  end

  def show
    respond_with @garment, template: "garments/show"
  end

  def create
    @admin_garment = ExhibitionChest.find(params[:exhibition_chest_id]).garments.build(garment_params)
    @admin_garment.save
     #大图 cover_image
    @admin_garment.update(cover_image_params)
    #detail_image, 3图
    @admin_garment.update(detail_image_1_params)
    @admin_garment.update(detail_image_2_params)
    @admin_garment.update(detail_image_3_params)
    respond_with @garment = @admin_garment, template: 'garments/show', status: 201
  end

  def update
    @garment = ExhibitionChest.find(params[:exhibition_chest_id]).garments.find(params[:id])

    @garment.update(garment_params)
    ##更新时可不传图片
    #大图 cover_image
    @garment.update(cover_image_params)
    #detail_image, 3图
    @garment.update(detail_image_1_params)
    @garment.update(detail_image_2_params)
    @garment.update(detail_image_3_params)
    #管理员入库衣服后 衣服状态改为 已入库
    @garment.do_finish_storing 
    #设置 入库时间 与 过期时间

    respond_with @garment, template: "garments/show", status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def delete_detail #detail_image_id
    @detail_image = @garment.detail_images.find(params[:detail_image_id])
    @detail_image.destroy
    respond_with @garment, template: "garments/show", status: 201
  end

  def destroy
    @garment.destroy
    respond_with @garment, template: 'garment/show', status: 204
  end

  private
    def set_admin_garment
      @garment = Garment.find(params[:id])
    end

    def garment_params
      params.require(:garment).permit(
        :title, :row, :carbit, :place, :description, :appointment_id
        )
    end

    def cover_image_params
      params.require(:garment).permit(
        cover_image_attributes: [:id, :photo, :_destroy]
        )
    end

    def detail_image_1_params
      params.require(:garment).permit(
        detail_image_1_attributes: [:id, :photo, :_destroy]
        )
    end

    def detail_image_2_params
      params.require(:garment).permit(
        detail_image_2_attributes: [:id, :photo, :_destroy]
        )
    end

    def detail_image_3_params
      params.require(:garment).permit(
        detail_image_3_attributes: [:id, :photo, :_destroy]
        )
    end

    # def detail_image_params
    #   params.require(:garment).permit(
    #     detail_images_attributes: [:id, :photo, :_destroy]
    #     )
    # end

end
