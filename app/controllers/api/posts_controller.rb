module Api
  class PostsController < CrudController

    private

    def post_params
      params.require(:post).permit(
        :content
      )
    end

  end
end
