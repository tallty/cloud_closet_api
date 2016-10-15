class Admin::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin, except: [:check, :reset] 

  before_action :set_admin_appointment, only: [:show, :update, :destroy]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @admin_appointments = Appointment.paginate(page: page, per_page: per_page)
    respond_with(@admin_appointments)
  end

  def show
    respond_with(@admin_appointment)
  end

  def create
    @admin_appointment = Admin::Appointment.new(admin_appointment_params)
    @admin_appointment.save
    respond_with(@admin_appointment)
  end

  def update
    @admin_appointment.update(admin_appointment_params)
    respond_with(@admin_appointment)
  end

  def destroy
    @admin_appointment.destroy
    respond_with(@admin_appointment)
  end

  private
    def set_admin_appointment
      @admin_appointment = Admin::Appointment.find(params[:id])
    end

    def admin_appointment_params
      params[:admin_appointment]
    end
end
