class AddUserTypeColumn < ActiveRecord::Migration
  def up
    add_column :users, :user_type, :integer, :null=>false, :default=>0
  end
end
