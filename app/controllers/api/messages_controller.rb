module Api
  class MessagesController < CrudController
    self.nesting = Chatroom
    self.permitted_attrs = ['message', 'chatroom_id', 'user_id']
    before_action :set_user_id_and_chat_room_id, only: :create

    private

    def set_user_id_and_chat_room_id
      params[:message][:user_id] = current_user.id
      params[:message][:chatroom_id] = params[:chatroom_id]
    end

  end
end
