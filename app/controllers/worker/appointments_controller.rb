class Worker::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Worker

  before_action :set_worker_appointment, only: [:show, :update, :destroy, :accept, :storing, :cancel]

  respond_to :json

  def index
    @appointments_hash = Appointment.all.appointment_state("committed").group_by(&:date)
    respond_with(@appointments_hash)
  end

  def show
    respond_with(@worker_appointment)
  end

  # def create
  #   @worker_appointment = Worker::Appointment.new(worker_appt_params)
  #   @worker_appointment.save
  #   respond_with(@worker_appointment)
  # end

  def accept
    @worker_appointment.accept!
    @worker_appointment.save
    respond_with(@worker_appointment)
  end

  def storing
    @worker_appointment.storing!
    @worker_appointment.save
    respond_with(@worker_appointment, template: "worker/appointments/accept", status: 200)
  end

  def cancel
    @worker_appointment.cancel!
    @worker_appointment.save
    respond_with(@worker_appointment, template: "worker/appointments/accept", status: 200)
  end

  def state_query
    Appointment.aasm.state_machine.states.collect(&:name).each do |state|
      instance_variable_set("@#{state}_appointments", Appointment.all.appointment_state(state).group_by(&:date))
    end
    respond_with template: "worker/appointments/state_query", status: 200
  end

  def update
    @worker_appointment = @worker_appointment.worker_update_appt(params)
    respond_with(@worker_appointment, template: "worker/appointments/show", status: 200)
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def destroy
    # @worker_appointment = Appointment.all.appointment_state("accepted").find(params[:id])
    @worker_appointment.destroy
    respond_with(@worker_appointment)
  end

  private
    def set_worker_appointment
      @worker_appointment = Appointment.find(params[:id])
    end

    def worker_appointment_params
      params[:worker_appointment]
    end
    def appt_params
      params.require(:appointment).permit(
          :remark, :care_type, :care_cost, :service_cost,
          :garment_count_info
        )
    end
    def appt_group_params
      params.require(:appointment_items).permit(
          price_groups: [
            :price_system_id, :count, :store_month,
          ]
        )
    end
end
