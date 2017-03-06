class Admin::ConstantTagsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin 
  before_action :set_constant_tag, only: [:show, :update, :destroy]
  respond_to :json

  def index
    @constant_tags = ConstantTag.class_is(params[:class_name])
    respond_with @constant_tags, template: 'constant_tags/index'
  end

  def show
    respond_with @constant_tag, template: 'constant_tags/show'
  end

  def create
    @constant_tag = ConstantTag.new(constant_tag_params)
    @constant_tag.save
    respond_with @constant_tag, template: 'constant_tags/show', status: 201
  end

  def update
    @constant_tag.update(constant_tag_params)
    respond_with @constant_tag, template: 'constant_tags/show', status: 201
  end

  def destroy
    @constant_tag.destroy
    respond_with(@constant_tag)
  end

  private
    def set_constant_tag
      @constant_tag = ConstantTag.find(params[:id])
    end

    def constant_tag_params
      params.require(:constant_tag).permit(
          :title, :class_type
        )
    end
end
