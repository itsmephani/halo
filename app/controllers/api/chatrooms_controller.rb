module Api
  class ChatroomsController < CrudController
    self.permitted_attrs = [:id, :user_id, :friend_id]
    before_action :check_chatroom, only: :create

    private

    def check_chatroom
      chatrooms = Chatroom.where({user_id: current_user.id, friend_id: params[:chatroom][:friend_id]})
      chatrooms = chatrooms.any? ? chatrooms : Chatroom.where({friend_id: current_user.id, user_id: params[:chatroom][:friend_id]})
      chatroom = chatrooms[0]
      if chatroom
        render json: {status: "success", status_code: 200, data: chatroom.as_json({current_user_id: current_user.id, params: params})}
      end
    end
  end
end
