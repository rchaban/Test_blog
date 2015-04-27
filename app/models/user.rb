class User < ActiveRecord::Base
  has_many :comment	
  has_many :article
  has_many :microposts, dependent: :destroy

  has_many :friendships
  has_many :friends,
           -> { where friendships: { status: 'accepted' } },
           through: :friendships

  has_many :requested_friends,
           -> { where friendships: { status: 'requested' } },
           through: :friendships,
           source: :friend

  has_many :pending_friends,
           -> { where friendships: { status: 'pending' } },
           through: :friendships,
           source: :friend


  before_save { self.email = email.downcase }
  before_create :create_remember_token

  acts_as_messageable

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 } 

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Это предварительное решение. См. полную реализацию в "Following users".
    Micropost.where("user_id = ?", id)
  end

  def mailboxer_email(object)
    email
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end                 
end
