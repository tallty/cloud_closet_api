class BillsController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for User
  before_action :set_bill, only: [:show]

  respond_to :json

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @bills = current_user.bills.paginate(page: page, per_page: per_page)
    respond_with(@bills)
  end

  def show
    respond_with(@bill)
  end

  def create
    @bill = current_user.bills.build(bill_params)
    @bill.save
    respond_with @bill,template: "bills/show", status: 201
  end

  def deposit_bill
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @deposit_bills = current_user.bills.deposit_record.paginate(page: page, per_page: per_page)
    respond_with(@deposit_bills)
  end

  def payment_bill
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @payment_bills = current_user.bills.payment_record.paginate(page: page, per_page: per_page)

    respond_with(@payment_bills)
  end

  private
    def set_bill
      @bill = current_user.bills.find(params[:id])
    end

    def bill_params
      params.require(:bill).permit(:amount, :sign)
    end
end
