class Admin::GarmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin 

  before_action :set_garment, only: [:show, :destroy, :delete_detail, :change_status]

  respond_to :json

  def index
    @garments = ExhibitionChest.find(params[:exhibition_chest_id]).garments
    respond_with @garments, template: 'garments/index'
  end

  def show
    respond_with @garment, template: "garments/show"
  end

  def create
    @garment = ExhibitionChest.find(params[:exhibition_chest_id]).garments.build(garment_params)
    @garment.tag_list.add(ConstantTag.tag_validate('garment', tag_params[:add_tag_list])) if tag_params[:add_tag_list]
    @garment.save
    # 大图 cover_image
    @garment.update(cover_image_params)
    #detail_image, 3图
    @garment.update(detail_image_1_params)
    @garment.update(detail_image_2_params)
    @garment.update(detail_image_3_params)
    respond_with @garment, template: 'garments/show', status: 201
  rescue => @error
    raise MyError.new(@error)
  end

  def update
    @garment = ExhibitionChest.find(params[:exhibition_chest_id]).garments.find(params[:id])
    @garment.tag_list.add(ConstantTag.tag_validate('garment', tag_params[:add_tag_list])) if tag_params[:add_tag_list]
    @garment.tag_list.remove(ConstantTag.tag_validate('garment', tag_params[:remove_tag_list])) if tag_params[:remove_tag_list]
    @garment.update!(garment_params)
    ##更新时可不传图片
    #大图 cover_image
    @garment.update(cover_image_params)
    #detail_image, 3图
    @garment.update(detail_image_1_params)
    @garment.update(detail_image_2_params)
    @garment.update(detail_image_3_params)
    #管理员入库衣服后 衣服状态改为 已入库
    # @garment.do_finish_storing 
    #设置 入库时间 与 过期时间
    respond_with @garment, template: "garments/show", status: 201
  rescue => @error
    raise MyError.new(@error)
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
    def set_garment
      @garment = Garment.find(params[:id])
    end

    def garment_params
      params.require(:garment).permit(
        :title, :row, :carbit, :status,
        :place, :description, :appointment_id,
        )
    end

    def tag_params
      params.require(:garment).permit(
        :add_tag_list, :remove_tag_list
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
