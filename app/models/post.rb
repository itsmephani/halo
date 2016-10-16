class Post < ApplicationRecord
  include Paginate

  belongs_to :user
  belongs_to :poster, class_name: 'User', optional: true
  
  has_many :likes, as: :likeable

  # create by user and posted on other's profile 
  scope :all_posts, ->(args){ where("user_id = ? OR poster_id = ?", "#{args[:current_user_id]}",  "#{args[:current_user_id]}") }

  def as_json(options = nil)
    options ||= {}
    user_date = user.basic_info
    poster_date = poster.try(:basic_info)
    super().merge({user: user_date, likes: likes, poster: poster_date})
  end

end
