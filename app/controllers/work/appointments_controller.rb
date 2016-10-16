class Work::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_work_appointment, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @appointments_hash = Appointment.all.group_by(&:date)
    respond_with(@appointments_hash)
  end

  def show
    respond_with(@work_appointment)
  end

  def create
    @work_appointment = Work::Appointment.new(work_appointment_params)
    @work_appointment.save
    respond_with(@work_appointment)
  end

  def update
    @work_appointment.update(work_appointment_params)
    respond_with(@work_appointment)
  end

  def destroy
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
end
