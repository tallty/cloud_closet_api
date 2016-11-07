class Work::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_work_appointment, only: [:show, :update, :destroy, :accept]

  respond_to :json

  def index
    @appointments_hash = Appointment.all.appointment_state("committed").group_by(&:date)
    respond_with(@appointments_hash)
  end

  def show
    respond_with(@work_appointment)
  end

  # def create
  #   @work_appointment = Work::Appointment.new(work_appointment_params)
  #   @work_appointment.save
  #   respond_with(@work_appointment)
  # end

  def accept
    @work_appointment.accept!
    @work_appointment.save
    respond_with(@work_appointment)
  end

  def state_query
    @query_state = params[:query_state].present? ? "accepted" : "query_state"
    @work_appointments = Appointment.all.appointment_state(@query_state) 
    respond_with(@work_appointments, template: "work/appointments/state_query", status: 200)
  end

  def update
    @work_appointment.groups.destroy_all
    appointment_item_group_params[:groups].each do |group_param|
      appointment_group = @work_appointment.groups.build(group_param)
      appointment_group.save
    end
    @work_appointment.create_group

    respond_with(@work_appointment, template: "work/appointments/show", status: 200)
  end

  def destroy
    @work_appointment.destroy
    respond_with(@work_appointment)
  end

  private
    def set_work_appointment
      @work_appointment = Appointment.all.appointment_state("committed").find(params[:id])
    end

    def work_appointment_params
      params[:work_appointment]
    end

    def appointment_item_group_params
      params.require(:appointment_item).permit(
          groups: [:count, :price, :store_month, :type_name]
        )
    end
end
