require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  # for sms_token accept in the sign_up interface
  before_action :configure_permitted_parameters, if: :devise_controller?
  # protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:sms_token])
    end
end
