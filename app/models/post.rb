class Post < ApplicationRecord
  include Paginate

  belongs_to :user
  
  def as_json(options = nil)
    options ||= {}
    super().merge({user: user})
  end

end
