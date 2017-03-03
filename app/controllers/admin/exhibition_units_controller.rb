class Admin::ExhibitionUnitsController < ApplicationController
  before_action :set_exhibition_unit, only: [:show, :update, :destroy]
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin, except: [:check, :reset] 
  respond_to :json

  def index
    @exhibition_units = ExhibitionUnit.all
    respond_with(@exhibition_units)
  end

  def show
    respond_with(@exhibition_unit)
  end

  def create
    @exhibition_unit = ExhibitionUnit.new(exhibition_unit_params)
    @exhibition_unit.save
    respond_with(@exhibition_unit)
  end

  def update
    @exhibition_unit.update(exhibition_unit_params)
    respond_with(@exhibition_unit)
  end

  def destroy
    @exhibition_unit.destroy
    respond_with(@exhibition_unit)
  end

  private
    def set_exhibition_unit
      @exhibition_unit = ExhibitionUnit.find(params[:id])
    end

    def exhibition_unit_params
      params[:exhibition_unit]
    end
end
