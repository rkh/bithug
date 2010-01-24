require "bithug"

module Bithug
  
  class AbstractUser < Ohm::Model
  end
  
  class User < AbstractUser
  end

  # A user of Bithug - nice and pretty
  class AbstractUser < Ohm::Model
    attribute :name
    set :following, Bithug::User
    set :followers, Bithug::User
    set :keys, Bithug::Key
    set :repositories, Bithug::Repository

    index :name

    def validate
      assert_present :name
    end
    # The method at the end of the authentication chain
    def self.authenticate(username, password, options = {})
      false
    end

    # The method to be called if an authentication succeeded
    def self.login(username)
      Bithug::User.find(:name => username).first || Bithug::User.create(:name => username)
    end
  end

end
