class Admin::InvoicesController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

  before_action :set_invoice, only: [:show, :update, :destroy]

  respond_to :json

  def index
  	page = params[:page] || 1
    per_page = params[:per_page] || 10
    @invoices = Invoice.all.paginate(page: page, per_page: per_page)
		respond_with @invoices, template: 'invoices/index', status: 200
  end

  def show
    respond_with @invoice, template: 'invoices/show', status: 200
  end

  # def create
  #   @invoice = current_user.invoices.new(invoice_params)
  #   @invoice.save!
  #   respond_with @invoice, template: 'invoices/show', status: 201
  # rescue => @error
  #   respond_with @error, template: 'error', status: 422
  # end

  # def update
  #   @invoice.update(invoice_params)
  #   respond_with(@invoice)
  # end

  def destroy
    @invoice.destroy
    respond_with(@invoice)
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      # params.require(:invoice).permit(
      #   :title, :amount, :invoice_type, 
      #   :cel_name, :cel_phone, :postcode, 
      #   :address
      #   )

    end

end