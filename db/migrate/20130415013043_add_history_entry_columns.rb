class AddHistoryEntryColumns < ActiveRecord::Migration
  def up
    drop_table :history_entries
    create_table :history_entries do |t|
      t.integer :user_id
      t.string :word
      t.string :letters_guessed
      t.integer :win
      t.timestamps
    end

  end

  def down
    drop_table :history_entries
  end
end
