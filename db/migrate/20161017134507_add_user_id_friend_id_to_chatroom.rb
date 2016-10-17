class AddUserIdFriendIdToChatroom < ActiveRecord::Migration[5.0]
  def change
    add_column :chatrooms, :user_id, :integer
    add_column :chatrooms, :friend_id, :integer
  end
end
