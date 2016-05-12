module Api
  class PostsController < CrudController
    self.permitted_attrs = [:id, :content, :user_id]

  end
end
