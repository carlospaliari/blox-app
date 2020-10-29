class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_basic("Restrict") do |email, password|
      @current_user = User.find_by(email: email)
      @current_user&.authenticate(password)
    end
  end
end
