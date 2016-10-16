class Work::AppointmentItemGroupsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_work_appointment_item_group, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @appointment = Appointment.find(params[:appointment_id])
    @work_appointment_item_groups = @appointment.groups
    respond_with(@work_appointment_item_groups)
  end

  def show
    respond_with(@work_appointment_item_group)
  end

  def create
    @work_appointment_item_group = Work::AppointmentItemGroup.new(work_appointment_item_group_params)
    @work_appointment_item_group.save
    respond_with(@work_appointment_item_group)
  end

  def update
    @work_appointment_item_group.update(work_appointment_item_group_params)
    respond_with(@work_appointment_item_group)
  end

  def destroy
    @work_appointment_item_group.destroy
    respond_with(@work_appointment_item_group)
  end

  private
    def set_work_appointment_item_group
      @work_appointment_item_group = Work::AppointmentItemGroup.find(params[:id])
    end

    def work_appointment_item_group_params
      params[:work_appointment_item_group]
    end
end
