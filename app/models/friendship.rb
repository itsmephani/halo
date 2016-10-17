class Friendship < ApplicationRecord
  include Paginate

  belongs_to :user
  belongs_to :friend, class_name: "User"

  scope :having_user, ->(args) { where("user_id = ? OR friend_id = ?", "#{args[:current_user_id]}",  "#{args[:current_user_id]}") }

  def as_json(options = nil)
    options ||= {}
    data = {user: user.basic_info, friend: friend.basic_info}
    super().merge(data)
  end
end
