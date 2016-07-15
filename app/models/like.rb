class Like < ApplicationRecord
  include Paginate

  belongs_to :user
  belongs_to :likeable, polymorphic: true

end
