require "bithug"

module Bithug

  class User < Ohm::Model
  end

  # A user of Bithug - nice and pretty
  module AbstractUser
    include Bithug::ServiceHelper
    
    attribute :name
    set :following, Bithug::User
    set :followers, Bithug::User
    set :ssh_keys, Bithug::Key
    set :repositories, Bithug::Repository

    index :name
    
    def following?(user)
      false
    end

    def validate
      assert_present :name
    end
    
    def writeable_repositories
      []
    end
    
    def readable_repositories
      []
    end

    class_methods do
      # The method at the end of the authentication chain
      def authenticate(username, password, options = {})
        false
      end
  
      # The method to be called if an authentication succeeded
      def login(username)
        Bithug::User.find(:name => username).first || Bithug::User.create(:name => username)
      end
    end
  end
  
  class User < Ohm::Model
    include Bithug::AbstractUser unless ancestors.include? Bithug::AbstractUser
  end

end
