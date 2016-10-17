class Message < ApplicationRecord
  include Desc
  include Paginate

  belongs_to :chatroom
  belongs_to :user
  after_create :broadcast_message

  def as_json(options = nil)
    options ||= {}
    data = {chatroom: chatroom, user_name: self.user.name}
    super().merge(data)
  end

  private

  def broadcast_message
    ActionCable.server.broadcast "message_chatroom_#{self.chatroom.id}",
        message: self.message,
        user_id: self.user.id,
        user_name: self.user.name,
        created_at: self.created_at
  end
end
