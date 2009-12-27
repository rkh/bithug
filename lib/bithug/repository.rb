require 'fileutils'
require 'ohm'
require 'ohm_ext'

class Bithug::Repository < Ohm::Model
  attribute :name
  attribute :public
  attribute :owner
  attribute :vcs
  set :readers
  set :writers

  index :name
  index :owner

  def validate
    assert_present :name
    assert_present :vcs
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
      hash = args.first.merge(:name => "#{hash[:owner].name}/#{hash[:name]}")
      repo = super(hash)
      repo.create_repository
      repo.save
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
