module Api
  class LikesController < CrudController
    self.permitted_attrs = ['id', 'likeable_id', 'likeable_type', 'user_id']

    before_action :set_user_id

    private
    
    def set_user_id
      params[:like][:user_id] = current_user.id
    end

  end
end
