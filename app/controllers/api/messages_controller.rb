module Api
  class MessagesController < CrudController
    self.permitted_attrs = ['message', 'chatroom_id']

  end
end
