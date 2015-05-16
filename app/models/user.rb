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

  has_many :conversations, :foreign_key => :sender_id         


  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 } 
  
  has_attached_file :avatar, :styles => {small: "500x500>", thumb: "500x500>"}, default_url: 'gravatar_1.png'
  validates_attachment :avatar,
                       :content_type => { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] } ,
                       :size => {:in => 0..1.megabytes}


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

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end                 
end
