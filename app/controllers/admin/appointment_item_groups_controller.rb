class Admin::AppointmentItemGroupsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin 

  before_action :set_admin_appointment_item_group, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @appointment = Appointment.find(params[:appointment_id])
    @admin_appointment_item_groups = @appointment.groups
    respond_with(@admin_appointment_item_groups)
  end

  def show
    respond_with(@admin_appointment_item_group)
  end

  def create
    @admin_appointment_item_group = Admin::AppointmentItemGroup.new(admin_appointment_item_group_params)
    @admin_appointment_item_group.save
    respond_with(@admin_appointment_item_group)
  end

  def update
    @admin_appointment_item_group.update(admin_appointment_item_group_params)
    respond_with(@admin_appointment_item_group)
  end

  def destroy
    @admin_appointment_item_group.destroy
    respond_with(@admin_appointment_item_group)
  end

  private
    def set_admin_appointment_item_group
      @admin_appointment_item_group = Admin::AppointmentItemGroup.find(params[:id])
    end

    def admin_appointment_item_group_params
      params[:admin_appointment_item_group]
    end
end
