module Bithug
  module AbstractRepository
  	include ServiceHelper
  
    attribute :name
    attribute :public
    attribute :vcs
    set :owner, Bithug::User
    set :readers, Bithug::User
    set :writers, Bithug::User

    index :name
    index :owner

    def validate
      assert_present :name
      assert_present :vcs
    end
    
    def create_repository
      raise ConfigurationError, "#{vcs} is an unhandled VCS"
    end

    def remove_repository
      raise ConfigurationError, "#{vcs} is an unhandled VCS"
    end

    # This is used by the shell
    def check_access_rights(user, writeaccess=false)
      user_name = username(user)
      unless self.owner == user_name
        unless self.readaccess.include?(user_name) || (self.public == true)
          raise ReadAccessDeniedError, 
              "#{self.owner} User #{user_name} does not have read-access"
        else
          unless (self.writeaccess.include?(user_name) || !writeaccess)
            raise WriteAccessDeniedError, 
                "User #{user_name} does not have write-access"
          end
        end
      end
    end

    class_methods do
      # Return all repositories that are writeable by the given user
      def writeable_repos(user)
        all.select do |repo|
          repo.writeaccess.include?(user)
        end
      end

      # Return all repositories that are readeable by the given user
      def readable_repos(user)
        all.select do |repo|
          repo.readaccess.include?(user)
        end
      end

      # This is overwritten to immediately create the underlying repo using the 
      # configured method, and also modify the name for uniqueness in the system 
      def create(options = {})
        owner = options.delete :owner
        options[:name] = owner.name / options[:name]
        super.tap do |repo|
          repo.create_repository
          repo.owner = owner
          repo.save
          owner.repositories << repo
          owner.save
        end
      end

      # Ohm only provides class matching for sets. Owner should be 
      # only one, anyhow, so provide accessors...  
      def owner=(user)
        owner.clear << user
      end

      def owner
        owner.first
      end

      # This is overwritten to actually remove the repository from storage or 
      # whatever is configured on delete
      def delete
        remove_repository
        super
      end
    end
  end

  class Repository < Ohm::Model
  	include AbstractRepository unless ancestors.include? AbstractRepository
  end

end
