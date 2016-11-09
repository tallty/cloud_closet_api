class Admin::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin, except: [:check, :reset] 

  before_action :set_admin_appointment, only: [:show, :update, :destroy, :stored]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @query_state = params[:query_state].present? ? params[:query_state] : "storing"
    @admin_appointments = Appointment.all.appointment_state(@query_state).by_join_date.paginate(page: page, per_page: per_page)
    respond_with(@admin_appointments)
  end

  def show
    respond_with(@admin_appointment)
  end

  def stored
    @admin_appointment.stored!
    @admin_appointment.save
    respond_with(@admin_appointment, template: "admin/appointments/show", status: 200)
  end

  def create
    @appointment = Admin::Appointment.new(appointment_params)
    @appointment.save
    respond_with @appointment, template: "appointments/show", status: 201
  end

  def update
    @appointment.update(appointment_params)
    respond_with @appointment, template: "appointments/show", status: 201
  end

  def destroy
    @appointment.destroy
    respond_with @appointment, template: "appointments/show", status: 204
  end

  private

    def set_admin_appointment
      @admin_appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params[:appointment]
    end
end
