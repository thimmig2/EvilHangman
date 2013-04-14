class HistoryEntry < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id
end
