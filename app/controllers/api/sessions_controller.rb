module Api
  class SessionsController < ApiController
    skip_before_filter :authenticate, only: :create
    before_action :user_has_token?, only: :create
    
    def create
      user = User.find_by(name: login_params[:name].downcase)
      if user.nil?
        return render :status => 401, :json => {status: "error", status_code: 401, errors: [{type: "login", code: 201, :message => "Username not found"}]}
      end
      if !user.authenticate(login_params[:password])
        return render :status => 401, :json => {status: "error", status_code: 401, errors: [{type: "login", code: 202, :message => "Incorrect Password"}]}
      end
      if user.reset_password_token.nil?
        return render status: 200, json: {status: "success", status_code: 200, data: user.as_json}
      else
        user.reset_password_token = nil
        if user.save
          return render status: 200, json: {status: "success", status_code: 200, data: user.as_json}
        else
          return render :status => 401, :json => {status: "error", status_code: 401, errors: [{type: "login", code: 272, :message => "Can't Update Reset Password Token, Something went wrong!"}]}
        end
      end
    end

    def destroy
      if @user
        reset_session
        cookies.delete :is_admin if cookies[:is_admin].present?
      end
      return render :status => 200, :json => {status: "success", status_code: 200, data: {:message => "Signout successfully!", type: "Signout", code: 107}}
    end

    private

    def login_params
      params.require(:user).permit(
        :name,
        :password
      )
    end

  end
end
