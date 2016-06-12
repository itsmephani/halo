class MessagesChannel < ApplicationCable::Channel

  def subscribed
    puts 'subscribed'
    stream_from 'messages'
  end
end
