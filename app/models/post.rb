class Post < ApplicationRecord
  include Paginate

  belongs_to :user
  
  has_many :likes, as: :likeable

  def as_json(options = nil)
    options ||= {}
    user_date = user.basic_info
    super().merge({user: user_date, likes: likes})
  end

end
