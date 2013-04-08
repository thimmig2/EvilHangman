class CreateHistoryEntries < ActiveRecord::Migration
  def change
    create_table :history_entries do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
