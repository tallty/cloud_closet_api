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

  # def create
  #   @garment = Garment.new(garment_params)
  #   @garment.save
  #   respond_with(@garment)
  # end

  def update
    @garment.tag_list.add(ConstantTag.tag_validate('garment', tag_params[:add_tag_list]))
    @garment.tag_list.remove(ConstantTag.tag_validate('garment', tag_params[:remove_tag_list]))
    @garment.update(garment_params) if garment_params
    respond_with @garment, template: 'garments/show', status: 201
    rescue => @error
      respond_with @error, template: 'error', status: 422
  end

  # def destroy
  #   @garment.destroy
  #   respond_with(@garment)
  # end

  private
    def set_garment
      @garment = current_user.garments.stored.find_by_id(params[:id])
      raise 'id 错误, 只允许用户编辑已上架衣服' unless @garment 
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
