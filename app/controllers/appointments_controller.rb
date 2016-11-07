class AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_appointment, only: [:show, :update, :destroy, :pay_by_balance]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @appointments = current_user.appointments.paginate(page: page, per_page: per_page)
    respond_with(@appointments)
  end

  def show
    respond_with(@appointment)
  end

  def create
    @appointment = current_user.appointments.build(appointment_params)
    @appointment.save
    respond_with @appointment, template: "appointments/show", status: 201
  end

  # def update
  #   @appointment.update(appointment_params)
  #   respond_with(@appointment)
  # end

  # def destroy
  #   @appointment.destroy
  #   respond_with(@appointment)
  # end

  def pay_by_balance
    
  end

  private
    def set_appointment
      @appointment = current_user.appointments.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(
        :address, :name, :phone, :number, :date
        )
    end
end
