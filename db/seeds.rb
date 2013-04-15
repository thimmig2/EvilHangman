HistoryEntry.delete_all

HistoryEntry.create(:user_id => 1, :word => 'bedtime', :letters_guessed => 'okengls', :win => 0)
HistoryEntry.create(:user_id => 2, :word => 'sleep', :letters_guessed => 'pels', :win => 1)
HistoryEntry.create(:user_id => 1, :word => 'ahhhh', :letters_guessed => 'ah', :win => 1)
HistoryEntry.create(:user_id => 3, :word => 'homework', :letters_guessed => 'workm', :win => 0)