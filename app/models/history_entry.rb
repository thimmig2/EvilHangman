class HistoryEntry < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :word, :letters_guessed, :win
end
