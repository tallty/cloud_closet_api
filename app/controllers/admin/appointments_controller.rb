class Admin::AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin, except: [:check, :reset] 

  before_action :set_admin_appointment, except: [:index, :create]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    # 筛选 state
    @query_state = params[:query_state].present? ? params[:query_state] : "storing"
    # 筛选用户
    appt = User.find_by_id(params[:user_id])&.appointments || Appointment.all
    # 是否由管理员创建
    appt = appt.created_by_admin if params[:created_by_admin]
    @admin_appointments = appt.appointment_state(@query_state).by_join_date.paginate(page: page, per_page: per_page)
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
    respond_with(@admin_appointment, template: "admin/appointments/show", status: 201)
  end

  def update
    @admin_appointment.update(appointment_params.as_json)
    respond_with @admin_appointment, template: "admin/appointments/show", status: 200
  end

  def create
    user = User.find_by_id(params[:user_id])
    if user
      @admin_appointment = Appointment.create_by_admin user, appt_params, appt_group_params
      respond_with @admin_appointment, template: "admin/appointments/show", status: 201
    else
      head 404
    end
  rescue => error
    render json: { error: error }, status: 422
  end

  def cancel
    @admin_appointment.cancel!
    respond_with @admin_appointment, template: "admin/appointments/show", status: 201
  end

  def recover # canceled -> unpaid
    @admin_appointment.recover!
    respond_with @admin_appointment, template: "admin/appointments/show", status: 201
  end

  def destroy # 只允许删除 canceled 订单
    @admin_appointment.soft_delete!
    respond_with @admin_appointment, template: "admin/appointments/show", status: 201
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

    def appt_params
      params.require(:appointment).permit(
          :remark, :care_type, :care_cost, :service_cost
        ) if params[:appointment]
    end
    
    def appt_group_params 
      params.require(:appointment_groups).permit(
        price_groups: [:price_system_id, :count, :store_month]
      ) if params[:appointment_groups]
    end
end
