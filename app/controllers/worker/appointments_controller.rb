class Worker::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Worker

  before_action :set_worker_appointment, only: [:show, :update, :destroy, :accept, :storing, :cancel]

  respond_to :json

  def index
    @appointments_hash = 
      Appointment.appointment_state("committed").not_by_admin.group_by(&:created_date)
    respond_with(@appointments_hash)
  end

  def show
    respond_with(@worker_appointment)
  end

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
    @hash = {
      accepted: [:accepted],
      waiting: [:unpaid, :paid],
      history: [:storing, :canceled]
    }

    @hash.each do |name, state_ary|
      instance_variable_set(
        "@#{name}_appointments", 
        Appointment.appointment_state(state_ary).not_by_admin.group_by(&:created_date)
      )
    end

    respond_with template: "worker/appointments/state_query", status: 200
  end

  def update
    @worker_appointment = @worker_appointment.worker_update_appt(appt_params, appt_group_params)
    @store_methods = StoreMethod.all
    respond_with(@worker_appointment, template: "worker/appointments/show", status: 200)
  rescue => @error
    raise MyError.new(@error)
  end

  def destroy
    @worker_appointment.soft_delete!
    head 204
  end

  private
    def set_worker_appointment
      @worker_appointment = Appointment.find(params[:id])
    end

    def appt_params
      appt_params = params.require(:appointment).permit(
          :remark, :care_type, :care_cost, :service_cost,
          garment_count_info: [:hanging, :stacking, :full_dress]
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
