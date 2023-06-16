class User < ApplicationRecord
  attr_accessor :remember_token

  scope :order_by_name, ->{order :name}

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :email, presence: true, length: {minimum: Settings.min_length_email, maximum: Settings.max_length_email},
    format: {with: Regexp.new(Settings.valid_email_regex)}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_length_password}, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end
  private

  def downcase_email
    email.downcase!
  end
end
