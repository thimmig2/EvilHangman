require'digest/sha2'

class User < ActiveRecord::Base
  validates :username, :password, :presence => true
  validates :username, :uniqueness => true

  validates :password, :confirmation => true
  validates :password, :length => {
      :minimum => 5
  }
  attr_accessor :password_confirmation
  attr_reader  :password
  validate :password_must_be_present

  attr_accessible :username, :password, :password_confirmation, :profile_image_url, :user_type

  has_many :history_entries, :dependent => :destroy

  def User.authenticate(username, password)
    if user = find_by_username(username)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  private
    def password_must_be_present
      errors.add(:password, "Missing Password") unless hashed_password.present?
    end

    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
