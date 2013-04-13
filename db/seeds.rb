User.delete_all

User.new(:username => "testAccount",
  :password => "tester",
  :password_confirmation => "tester"
)
