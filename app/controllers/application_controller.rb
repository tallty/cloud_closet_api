require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  # for sms_token accept in the sign_up interface
  before_action :configure_permitted_parameters, if: :devise_controller?

  class MyError < RuntimeError
  end

  rescue_from 'MyError' do |exception|
    Rails.logger.info ' --------- exception ---------'
    Rails.logger.info exception.message
    render json: exception, status: 422
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:sms_token])
    end
end
