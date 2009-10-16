require 'fileutils'
require 'user'
require 'ohm'

class Repository < Ohm::Model
  attribute :name
  attribute :public
  attribute :owner
  set :readaccess, User
  set :writeaccess, User

  index :name

  def validate
    assert_present :name
  end

  def grant_readaccess(user)
    self.readaccess << user
  end
  
  def grant_writeaccess(user)
    grant_readaccess(user)
    self.writeaccess << user
  end

  def check_access_rights(user, writeaccess=false)
    unless self.owner == user.name
      unless self.readaccess.include?(user) || (self.public == true)
        raise ReadAccessDeniedError, "#{self.owners} User #{user.name} does not have read-access"
      else
        unless (self.writeaccess.include?(user) || !writeaccess)
          raise WriteAccessDeniedError, "User #{user.name} does not have write-access"
        end
      end
    end
  end

  def self.repo_path_for(hash)
    "#{File.expand_path("~")}/#{hash[:owner].name}/#{hash[:name]}"
  end

  def self.create_empty_git_repo(path)
    FileUtils.mkdir_p(path)
    Dir.chdir(path)
    system("git init --bare")
  end

  def self.delete_git_repo(path)
    FileUtils.rm_rf(path)
  end

  def self.create(*args)
    hash = args.first
    create_empty_git_repo(repo_path_for(hash))
    repo = super(:name => "#{hash[:owner].name}/#{hash[:name]}", :owner => hash[:owner].name)
    repo.save
    repo
  end

  def self.delete
    delete_git_repo(repo_path_for(hash))
    super
  end
end
