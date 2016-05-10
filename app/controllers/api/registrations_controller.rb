module Api
  class RegistrationsController < ApiController
    
    skip_before_filter :authenticate
    before_action :check_current_user?
    
    def create
      params[:user][:email].downcase!
      user = User.new(user_params)
      save_user user
    end

    def auth_user_login
      provider = Provider.new
      if User::AUTH_PROVIDERS.include?(params[:provider]) && params[:access_token].present?
        auth_user_details = provider.get_auth_user_details(params)
        return render status: 404, json: {status: "error", status_code: 404,  errors: [{message: "#{params[:provider]} User not Found!", type: "#{params[:provider]}  Login", code: 111}]} if auth_user_details.nil?
        if !auth_user_details['email'].blank? && !( user = User.where(email: auth_user_details['email']).first ).nil?
          set_session(user)
        else
          if !auth_user_details['email'].blank? && !auth_user_details['first_name'].blank?
            auth_user_params = {name: auth_user_details['first_name'].to_s + auth_user_details['last_name'].to_s, email: auth_user_details['email'].downcase, about_me: auth_user_details['bio'], provider: params[:provider]}
            user = User.new(auth_user_params)
            user.email_verified = true
            user.remote_avatar_url = auth_user_details['picture']['data']['url'] if(auth_user_details['picture'] && auth_user_details['picture']['data'] && auth_user_details['picture']['data']['url'].present?  )
            save_user user
          else
            render status: 422, json: {status: "error", status_code: 422, errors: [{message: "Not enough details from #{params[:provider]}, either your name or email is private!", type: "#{params[:provider]}  Login", code: 101}]}
          end
        end
      else
        render status: 422, json: {status: "error", status_code: 422,  errors: [{message: "Unknown Provider or Access Token!", type: "#{params[:provider]}  Login", code: 112}]}
      end
    end

    def send_password_reset
      user = User.find_by_email(params[:email])
      if user.nil?
        render status: 404, json: {status: "error", status_code: 404, errors: [{message: 'No User with this Email!', type: 'Send Password Reset', code: 201}]}
      else
        generate_token(user, :reset_password_token)
        user.reset_password_sent_at = Time.zone.now
        user.save
        PasswordResetMailerJob.perform_later(user.id)
        render json: {status: "success", status_code: 200, data: {message: "Mail has been sent, Follow the mail for Instructions!", type: "Send Password Reset", code: 102}}
      end
    end

    def reset_password
      user = User.where(reset_password_token: params[:token]).first
      if user.nil?
        render status: 404, json: {status: "error", status_code: 404, errors: [{message: "Sorry, Token seems to be invalid!", type: 'Reset Password', code: 113}]}
      else
        if user.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
          generate_token(user, :access_token)
          user.reset_password_token = nil
          if user.save
            render json: { status: "success", status_code: 200 , data: user.as_json}
          else
            render json: {status: "error", status_code: 422}.merge(user.error_messages), status: 422
          end
        else
          render status: 404, json:  { status: "error", status_code: 404}.merge(user.error_messages({code: 114, type: 'Reset Password'}))
        end
      end
    end

    def verify_user
      return render status: 404, json: {status: "error", status_code: 404, errors: [{message: "Token can not be empty!", type: 'Verification', code: 113}]} unless params[:token].present?
      user = User.where(verification_token: params[:token]).first
      if user.nil?
        render status: 404, json: {status: "error", status_code: 404, errors: [{message: "Sorry, Verification Token seems to be invalid!", type: 'Verification', code: 113}]}
      else
        attrs = {}
        attrs[:email_verified] = true unless params[:work].present?
        attrs[:is_work_email_verified] = true if params[:work].present?
        if user.update_attributes(attrs)
          render json: { status: "success", status_code: 200 , data: user.as_json}
        else
          render status: 404, json:  { status: "error", status_code: 404}.merge(user.error_messages({code: 114, type: 'Verification'}))
        end
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :about_me,
        :mobile_number,
        :device_id,
        :device_token,
        :platform,
        :vehicle_type
      )
    end

    def generate_token(user, column)
      begin
        user[column] = SecureRandom.urlsafe_base64 + Time.now.strftime("%m%d%y%H%M%S%L")
      end while User.exists?(column => user[column])
    end

    def check_current_user?
      render status: 422, json: {status: "error", status_code: 422, errors: [{message: "Already SignedIn!", code: 222, type: "#{params[:action]}"}]} if current_user
    end

    def save_user user
      if user.save
        set_session user
      else
        render json: {status: "error", status_code: 422}.merge(user.error_messages), status: 422
      end
    end

    def set_session user
      #session[:user_id] = user.id
      return render status: 200, json: {status: "success", status_code: 200, data: user.as_json}
    end
  end
end