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
    attribute :real_name
    attribute :email

    set :following, Bithug::User
    set :followers, Bithug::User
    set :ssh_keys, Bithug::Key
    set :repositories, Bithug::Repository

    set :forks, Bithug::LogInfo::ForkInfo
    set :rights, Bithug::LogInfo::RightsInfo
    set :network, Bithug::LogInfo::FollowInfo
    set :commits, Bithug::LogInfo::CommitInfo

    index :name
    
    def recent_activity(num=10)
      ([commits, forks, rights, network].collect do |ary| 
        Bithug::LogInfo.recent(ary, num)
      end.flatten.sort_by do |i|
        i.date_time
      end)[0..num]
    end
    
    def following?(user)
      following.all.include? user
    end

    def log_following(user, start = :true)
      Bithug::LogInfo::FollowInfo.create.tap do |f|
        f.active_user = self
        f.passive_user = user
        f.started_following = start
      end.save
    end

    def follow(user)
      log_following(user, :true)
      following.add(user)
      user.followers.add(self)
    end

    def unfollow(user)
      log_following(user, :false)
      following.delete(user)
      user.followers.delete(self)
    end
    
    def grant_access(options)
      options[:access] ||= :r
      options[:repo] ||= options[:repository]
      options[:repo].grant_access(options)
      options[:access] = "+#{options[:access]}"
      log_access_rights(options)
      save
    end

    def revoke_access(options)
      options[:access] ||= :w
      options[:repo] ||= options[:repository]
      options[:repo].revoke_access(options)
      options[:access] = "-#{options[:access]}"
      log_access_rights(options)
      save
    end

    def log_access_rights(options)
      Bithug::LogInfo::RightsInfo.create.tap do |r|
        r.admin = self
        r.changed_user = options[:user]
        r.repository = options[:repo]
        r.access_change = options[:access]
      end.save
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
