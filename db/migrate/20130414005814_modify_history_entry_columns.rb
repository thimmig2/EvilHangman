class ModifyHistoryEntryColumns < ActiveRecord::Migration
  def up
    add_column :history_entries, :word, :string
    add_column :history_entries, :letters_guessed, :string
  end

  def down
    remove_column :history_entries, :word
    remove_column :history_entries, :letters_guessed
  end
end
