class MessagesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "message_chatroom_#{params[:chatroom_id]}"
  end
end
