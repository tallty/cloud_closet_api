class PurchaseLogsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User

  before_action :set_purchase_log, only: [:show]

  respond_to :json

  def index
    @purchase_logs = current_user.user_info.purchase_logs
    respond_with(@purchase_logs)
  end

  def show
    respond_with(@purchase_log)
  end

  # def create
  #   @purchase_log = current_user.user_info.purchase_logs.new(purchase_log_params)
  #   @purchase_log.save
  #   respond_with(@purchase_log)
  # end

  # def update
  #   @purchase_log.update(purchase_log_params)
  #   respond_with(@purchase_log)
  # end

  # def destroy
  #   @purchase_log.destroy
  #   respond_with(@purchase_log)
  # end

  private
    def set_purchase_log
      @purchase_log = current_user.user_info.purchase_logs.find(params[:id])
    end

    # def purchase_log_params
    #   params[:purchase_log]
    # end
end
