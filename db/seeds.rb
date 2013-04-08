User.delete_all

User.create(:username => "firstUser",
            :password => "shouldBeHashed",
            :profile_image_url => "")

User.create(:username => "randomGuy",
            :password => "hashedPass",
            :profile_image_url => "http://www.nawang.com/Photos/10Logos/Profile_LOGO.jpg")