class AppointmentItemGroupsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_appointment_item_group, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @appointment = current_user.appointments.find(params[:appointemnt_id])
    @appointment_item_groups = @appointment.groups
    respond_with(@appointment_item_groups)
  end

  def show
    respond_with(@appointment_item_group)
  end

  def create
    @appointment_item_group = AppointmentItemGroup.new(appointment_item_group_params)
    @appointment_item_group.save
    respond_with(@appointment_item_group)
  end

  def update
    @appointment_item_group.update(appointment_item_group_params)
    respond_with(@appointment_item_group)
  end

  def destroy
    @appointment_item_group.destroy
    respond_with(@appointment_item_group)
  end

  private
    def set_appointment_item_group
      @appointment_item_group = AppointmentItemGroup.find(params[:id])
    end

    def appointment_item_group_params
      params[:appointment_item_group]
    end
end
