module Api
  class ChatroomsController < ApiController

    def show
      @chatroom = Chatroom.find_by(id: params[:id])
      @message = Message.new
    end
  end
end
