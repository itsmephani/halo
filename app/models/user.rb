class User < ApplicationRecord
  include Paginate

  has_many :posts
  
  has_secure_password validations: false
  validates :password, confirmation: true
  validates :password, :length => { :minimum => 6 }, :if => :password_digest_changed?
  validates :password, :presence=>true, :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :password_digest_changed?
  validates :email, :name, uniqueness: true
  validates :email, presence: true
  
  before_create :generate_access_token

  scope :search, ->(args){ where("name ilike ? OR email ilike ? OR about_me ilike ?", "%#{args[:q]}%",  "%#{args[:q]}%", "%#{args[:q]}%") }
  
  def as_json(options = nil)
    options ||= {}
    super().merge({})
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
    else
      throw(:abort)
    end
  end

end