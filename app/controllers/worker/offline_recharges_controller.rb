class Worker::OfflineRechargesController < ApplicationController
	include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Worker

  before_action :set_offline_recharge, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @offline_recharges = OfflineRecharge.all
    respond_with @offline_recharges, template: 'offline_recharges/index', status: 200
  end

  def show
    respond_with @offline_recharge, template: 'offline_recharges/show', status: 200
  end

  def create
  	raise '用户id 错误' unless User.find_by_id( offline_recharge_params[:user_id] )
    @offline_recharge =  current_worker.offline_recharges.build( offline_recharge_params )
    @offline_recharge.save
    respond_with @offline_recharge, template: 'offline_recharges/show', status: 201
  rescue => @error
  	respond_with @error, template: 'error', status: 422
  end

  # def update
  #   @offline_recharge.update(offline_recharge_params)
  #   respond_with(@offline_recharge)
  # end

  # def destroy
  #   @offline_recharge.destroy
  #   respond_with(@offline_recharge)
  # end

  private
    def set_offline_recharge
      @offline_recharge = OfflineRecharge.find(params[:id])
    end

    def offline_recharge_params
    	params.require(:offline_recharge).permit(
    			:amount, :credit, :user_id
    		)
    end
end
