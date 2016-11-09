class Work::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_work_appointment, only: [:show, :update, :destroy, :accept, :storing, :cancel]

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

  def storing
    @work_appointment.storing!
    @work_appointment.save
    respond_with(@work_appointment, template: "work/appointments/accept", status: 200)
  end

  def cancel
    @work_appointment.cancel!
    @work_appointment.save
    respond_with(@work_appointment, template: "work/appointments/accept", status: 200)
  end

  def state_query
    # page = params[:page] || 1
    # per_page = params[:per_page] || 10
    # @query_state = params[:query_state].present? ? params[:query_state] : "accepted" 
    # (accepted: 服务中,unpaid: 待付款, paid: 已支付,storing: 入库中，canceled: 已取消)
    @accepted_appointments = Appointment.all.appointment_state("accepted").group_by(&:date)#.by_join_date.paginate(page: page, per_page: per_page) 
    @unpaid_appointments = Appointment.all.appointment_state("unpaid").group_by(&:date)
    @paid_appointments = Appointment.all.appointment_state("paid").group_by(&:date)
    @storing_appointments = Appointment.all.appointment_state("storing").group_by(&:date)
    @canceled_appointments = Appointment.all.appointment_state("canceled").group_by(&:date)
    respond_with(@accepted_appointments, @unpaid_appointments, @paid_appointments, @storing_appointments, 
                 @canceled_appointments, template: "work/appointments/state_query", status: 200)
  end

  def update
    # @work_appointment = Appointment.all.appointment_state("accepted").find(params[:id])
    @work_appointment.groups.destroy_all
    appointment_item_group_params[:groups].each do |group_param|
      appointment_group = @work_appointment.groups.build(group_param)
      appointment_group.save
    end
    @work_appointment.create_group

    respond_with(@work_appointment, template: "work/appointments/show", status: 200)
  end

  def destroy
    # @work_appointment = Appointment.all.appointment_state("accepted").find(params[:id])
    @work_appointment.destroy
    respond_with(@work_appointment)
  end

  private
    def set_work_appointment
      @work_appointment = Appointment.find(params[:id])
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
