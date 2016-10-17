class RemoveNameFromChatrooms < ActiveRecord::Migration[5.0]
  def change
    remove_column :chatrooms, :name
  end
end
