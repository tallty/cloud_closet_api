class Admin::InvoicesController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin

  before_action :set_invoice, except: :index

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
  
  def accept
    @invoice.accept!
    head 200
  end

  def destroy
    @invoice.destroy
    respond_with(@invoice)
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

end