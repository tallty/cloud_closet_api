class AppointmentsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_appointment, only: [:show, :update, :destroy, :pay_by_balance, :cancel]

  respond_to :json

  def index
    @appointments = current_user.appointments
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
    @user_info = current_user.user_info
    if @user_info.balance < @appointment.price
      _insufficient = "%.2f"%(@appointment.price - @user_info.balance)

      @error = "余额不足, 需充值#{_insufficient}元"
      render @error, template: "error", status: 201
      #render json: {error: '余额不足'}  missing template
    else
      #生成消费记录 并扣费
      @purchase_log = PurchaseLog.create_one_with_storing_garment(@appointment)

      if @purchase_log
        @appointment.pay!
        
        respond_with @appointment, status: 201
      else
        @error = '余额扣费失败'
        render @error, template: "error", status: 201
      end
    end
  end
  def cancel
    @appointment.cancel!
    respond_with @appointment, template: "appointments/show", status: 201
  end


  private
    def set_appointment
      @appointment = current_user.appointments.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(
        :address, :name, :phone, :number, :date#,:detail 提供详情可修改
        )
    end
end
