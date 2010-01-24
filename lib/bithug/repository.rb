module Bithug
  class AbstractRepository
    include DataMapper::Resource

    property    :id,      Serial
    property    :name,    String, :required => true, :key => true
    property    :vcs,     String, :required => true
    property    :public,  Boolean, :default => false
    belongs_to  :owner,   'Bithug::User'
    has n,      :readers, 'Bithug::User'
    has n,      :writers, 'Bithug::User'
    
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

    class << self
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
      def create(*args)
        creation_hash = args.first.merge(:name => "#{args.first[:owner].name}/#{args.first[:name]}")
        owner = creation_hash.delete(:owner)
        repo = super(creation_hash)
        repo.create_repository
        repo.owner = owner
        repo.save
        owner.repositories << repo
        owner.save
        repo
      end

      # This is overwritten to actually remove the repository from storage or 
      # whatever is configured on delete
      def delete
        remove_repository
        super
      end
    end
  end

  class Repository < AbstractRepository
  end

end
