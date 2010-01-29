require "bithug"

module Bithug

  # We use the User class in the AbstractUser
  # We need to pre-define it  
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

    set :forks, Bithug::LogInfo::ForkInfo
    set :rights, Bithug::LogInfo::RightsInfo
    set :network, Bithug::LogInfo::FollowInfo
    set :commits, Bithug::LogInfo::CommitInfo

    index :name
    
    def following?(user)
      following.include? user
    end

    def validate
      assert_present :name
    end

    def writeable_repositories
      connected_repositories(:writers)
    end
    
    def readable_repositories
      connected_repositories(:readers)
    end

    def connected_repositories(via)
      Bithug::Repository.all.select {|r| r.send(via).include? self}
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
