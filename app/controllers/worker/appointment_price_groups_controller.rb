class Worker::AppointmentPriceGroupsController < ApplicationController
  before_action :set_worker_appointment_price_group, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @worker_appointment_price_groups = Worker::AppointmentPriceGroup.all
    respond_with(@worker_appointment_price_groups)
  end

  def show
    respond_with(@worker_appointment_price_group)
  end

  def create
    @worker_appointment_price_group = Worker::AppointmentPriceGroup.new(worker_appointment_price_group_params)
    @worker_appointment_price_group.save
    respond_with(@worker_appointment_price_group)
  end

  def update
    @worker_appointment_price_group.update(worker_appointment_price_group_params)
    respond_with(@worker_appointment_price_group)
  end

  def destroy
    @worker_appointment_price_group.destroy
    respond_with(@worker_appointment_price_group)
  end

  private
    def set_worker_appointment_price_group
      @worker_appointment_price_group = Worker::AppointmentPriceGroup.find(params[:id])
    end

    def worker_appointment_price_group_params
      params[:worker_appointment_price_group]
    end
end
