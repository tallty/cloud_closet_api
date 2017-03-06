class ConstantTagsController < ApplicationController
  before_action :set_constant_tag, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @constant_tags = ConstantTag.class_is(params[:class_name])
    respond_with(@constant_tags)
  end

  def show
    respond_with(@constant_tag)
  end

  def create
    @constant_tag = ConstantTag.new(constant_tag_params)
    @constant_tag.save
    respond_with(@constant_tag)
  end

  def update
    @constant_tag.update(constant_tag_params)
    respond_with(@constant_tag)
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
      params[:constant_tag]
    end
end
