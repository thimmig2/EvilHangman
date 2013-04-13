class DeleteSessionsTable < ActiveRecord::Migration
  def up
    drop_table :sessions
  end
end
