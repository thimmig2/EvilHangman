class ChangeUserTable < ActiveRecord::Migration
  def up
      drop_table :users
      create_table :users do |t|
        t.string :username
        t.string :hashedPassword
        t.string :salt
        t.string :profile_image_url

        t.timestamps
    end
  end
end
