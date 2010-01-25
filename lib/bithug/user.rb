require "bithug"

module Bithug

  class User < Ohm::Model
  end

  # A user of Bithug - nice and pretty
  module AbstractUser
    include ServiceHelper
    
    attribute :name
    set :following, Bithug::User
    set :followers, Bithug::User
    set :keys, Bithug::Key
    set :repositories, Bithug::Repository

    index :name

    def validate
      assert_present :name
    end

    class_methods do
      # The method at the end of the authentication chain
      def authenticate(username, password, options = {})
      	puts "Fallback..."
        false
      end
  
      # The method to be called if an authentication succeeded
      def login(username)
        Bithug::User.find(:name => username).first || Bithug::User.create(:name => username)
      end
    end
  end
  
  class User < Ohm::Model
    include AbstractUser unless ancestors.include? AbstractUser
  end

end
