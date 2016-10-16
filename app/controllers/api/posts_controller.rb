module Api
  class PostsController < CrudController
    self.permitted_attrs = [:id, :content, :user_id, :poster_id]
    before_action :set_params_user_id, only: :create

    private

    def set_params_user_id
      if params['post']['user_id'] != current_user.id && params['post']['poster_id'] != current_user.id
        params['post']['user_id'] = current_user.id
        params.delete :post['poster_id']
      end
    end

  end
end
