class User < ActiveRecord::Base
  validates :username, :password, :presence => true
  validates :username, :uniqueness => true
  validates :password, :length => {
      :minimum => 5
  }

  has_many :history_entries, :dependent => :destroy
  has_one :session, :dependent => :destroy
  attr_accessible :id, :password, :profile_image_url, :username
end
