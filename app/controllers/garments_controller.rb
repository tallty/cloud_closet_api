class GarmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_garment, only: [:show, :update]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @garments = current_user.garments.where(status: 'stored').paginate(page: page, per_page: per_page)
    respond_with(@garments)
  end

  def show
    respond_with(@garment)
  end

  def update
    @garment.tag_list.add(ConstantTag.tag_validate('garment', tag_params[:add_tag_list]))
    @garment.tag_list.remove(ConstantTag.tag_validate('garment', tag_params[:remove_tag_list]))
    @garment.update(garment_params) if garment_params
    respond_with @garment, template: 'garments/show', status: 201
    rescue => @error
      respond_with @error, template: 'error', status: 422
  end

  def basket
    @garments = current_user.garments.in_basket
    respond_with @garments, template: 'garments/index', status: 200
  end

  def add_them_to_basket # params[:garment_ids]
    change_status(['stored'], 'in_basket')
  end

  def get_out_of_basket
    change_status(['in_basket'], 'stored')
  end

  private
    def set_garment
      @garment = current_user.garments.stored.find_by_id(params[:id])
      raise 'id 错误, 只允许用户编辑已上架衣服' unless @garment 
    end

    def change_status from, to
      DeliveryService.new(current_user).change_garments_status(params, from, to)
      head 201 
    rescue => @error
      respond_with @error, template: 'error', status: 422
    end

    def garment_params
      params.require(:garment).permit(
        
        )
    end

    def tag_params
      params.require(:garment).permit(
        :add_tag_list, :remove_tag_list
        )
    end
end
