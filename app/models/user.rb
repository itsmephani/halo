class User < ApplicationRecord
  include Paginate

  mount_uploader :avatar, AvatarUploader

  has_many :posts
  has_many :messages
  has_many :chatrooms, through: :messages
  has_many :friendships
  has_many :friends, :through => :friendships

  has_secure_password validations: false
  validates :password, confirmation: true
  validates :password, :length => { :minimum => 6 }, :if => :password_digest_changed?
  validates :password, :presence=>true, :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :password_digest_changed?
  validates :email, :name, uniqueness: true
  validates :email, presence: true

  before_create :generate_access_token

  scope :search, ->(args){ where("name ilike ? OR email ilike ?", "%#{args[:q]}%",  "%#{args[:q]}%") }

  def as_json(options = nil)
    options ||= {}
    data = {}
    if options[:current_user_id]
      data['is_friend'] = self.is_friend_of options[:current_user_id]
    end
    super().merge(data)
  end

  def basic_info
    self.slice('id', 'name', 'email', 'avatar')
  end

  def is_friend_of user_id
    Friendship.exists?({user_id: "#{user_id}", friend_id: "#{self.id}"}) ||
        Friendship.exists?({user_id: "#{self.id}", friend_id: "#{user_id}"})
  end


  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex + Time.now.strftime("%m%d%y%H%M%S%L")
    end while self.class.exists?(access_token: access_token)
  end

  def should_validate_password?
    if provider.nil? && new_record?
      true
    end
  end

end
