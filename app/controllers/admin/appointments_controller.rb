class Admin::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin, except: [:check, :reset] 

  before_action :set_admin_appointment, only: [:show, :update, :its_chests, :destroy, :stored]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @query_state = params[:query_state].present? ? params[:query_state] : "storing"
    appointments = User.find_by_id(params[:user_id]).try(:appointments) || Appointment.all
    @admin_appointments = appointments.appointment_state(@query_state).by_join_date.paginate(page: page, per_page: per_page)
    respond_with(@admin_appointments)
  end

  def show
    respond_with(@admin_appointment)
  end

  def its_chests
    @exhibition_chests = @admin_appointment.user.his_chest_not_full
    # @exhibition_chests = ExhibitionChestViewService.new(@exhibition_chests).in_user_index
    respond_with @exhibition_chests, template: 'admin/exhibition_chests/index'
  end

  def stored
    @admin_appointment.stored!
    @admin_appointment.save
    respond_with(@admin_appointment, template: "admin/appointments/show", status: 201)
  end

  def update
    @admin_appointment.update(appointment_params.as_json)
    respond_with @admin_appointment, template: "admin/appointments/show", status: 200
  end

  private

    def set_admin_appointment
      @admin_appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(
        garment_count_info: [:hanging, :stacking, :full_dress]
      )
    end
end
