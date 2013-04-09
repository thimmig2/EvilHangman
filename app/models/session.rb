class Session < ActiveRecord::Base

  belongs_to :user

  attr_accessible :user_id
  # attr_accessible :title, :body
end
