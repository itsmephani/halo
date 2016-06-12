class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user
  after_create :broadcast_message

  private

  def broadcast_message
    ActionCable.server.broadcast 'messages',
        message: self.message,
        user: self.user.name
  end
end
