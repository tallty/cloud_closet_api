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
    @appointment = Appointment.find(params[:appointment_id])
    @appointment_item_group =  @appointment.groups.build(appointment_item_group_params)
    @appointment_item_group.save
    respond_with(@appointment_item_group, template: "appointment_item_groups/show", status: 201)
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
      @work_appointment_item_group = AppointmentItemGroup.find(params[:id])
    end

    def appointment_item_group_params
      params.require(:appointment_item_group).permit(
          :count, :price, :store_month
        )
    end
end
