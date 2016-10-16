module Api
  class UsersController < CrudController
    self.permitted_attrs = ["id", "name", "email", "avatar", "password", "password_confirmation"] 
    before_action :parse_params, only: [:create, :update]

    def me
      render json: {status: "success", status_code: 200, data: current_user.as_json}
    end

    def entry
      if  params['action'] == 'show'
        super 
      else
        current_user
      end
    end

    private
    
    def parse_params
      params[:user].delete :avatar if( params[:user].present? && params[:user][:avatar].present? && params[:user][:avatar].is_a?(String) )
    end

  end
end
