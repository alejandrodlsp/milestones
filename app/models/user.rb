class User < ApplicationRecord
  RESET_PASSWORD_TOKEN_VALIDITY = 4.hours.freeze

  has_secure_password
  has_one_attached :image
  has_many :lists, dependent: :destroy
  has_many :milestones, dependent: :destroy

  # Amistades que el usuario envió
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend

  # Amistades que recibió
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
  /x

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 50 },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name,
    presence: true,
    length: { maximum: 20 }

  validates :last_name,
    presence: true,
    length: { maximum: 30 }

  validates :password,
    presence: true,
    length: { minimum: 8 },
    format: { with: PASSWORD_FORMAT }, on: :create

  def generate_password_token!
    self.reset_password_token = SecureRandom.hex(20)
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    return false if self.reset_password_sent_at.nil?
    (self.reset_password_sent_at + RESET_PASSWORD_TOKEN_VALIDITY) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    self.password = password
    save!
  end

  def increment_login_attempts!
    self.loging_attempts = self.loging_attempts + 1
    save!
  end

  def reset_login_attempts!
    self.loging_attempts = 0
    self.last_login = DateTime.now
    save!
  end

  def timeout
    attempts_timeouts = [ 0, 0, 0, 1, 20, 60 ]
    self.loging_attempts < attempts_timeouts.length ? attempts_timeouts[self.loging_attempts] : 120
  end

  def can_login?
    self.last_login_attempt + timeout.minutes < DateTime.now
  end

  def all_friends
    friends_accepted + inverse_friends_accepted
  end
  
  def friends_accepted
    friendships.where(status: 'accepted').map(&:friend)
  end
  
  def inverse_friends_accepted
    inverse_friendships.where(status: 'accepted').map(&:user)
  end

  def friendship_status(user)
    friendship = Friendship.find_by(user: self, friend: user) || Friendship.find_by(user: user, friend: self)

    return 'same_user' if user.id == self.id
    return 'not_friends' if friendship.nil?

    return 'pending' if friendship.user == user && friendship.status == 'pending'
    return 'sent' if friendship.user == self && friendship.status == 'pending'

    friendship.status
  end

  def admin?
    role == "admin"
  end
end
