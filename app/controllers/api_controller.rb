class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_filter  :verify_authenticity_token

  include ActionController::Cookies
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection
  include ActionController::RequestForgeryProtection
  include ActionController::HttpAuthentication::Token::ControllerMethods #authenticate_or_request_with_http_token
  before_filter :authenticate
  
  def current_user
    @user
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(access_token: token)
    end
  end

  def render_unauthorized
    render status: 401, json: {status: "error", status_code: 401, errors: [{ code: 0, type: 'Authentication', message: 'HTTP Token: Access denied.!'}]}
  end

  def user_has_token?
    begin
      if request.headers["HTTP_AUTHORIZATION"].split('token=')[1].gsub('"', '')
        validate_current_user ? (return render(json: {status: "error", status_code: 401, errors: [{code: 1, type: 'Token Exists', message: 'You Already have a Token!'}]}) ) : ''
      end
    rescue
      ''
    end
  end
  
end
