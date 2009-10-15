require 'fileutils'
require 'ohm'

class Repository < Ohm::Model
  attribute :name
  attribute :public
  set :owners, User
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
    unless self.readaccess.include?(user)
      raise Serve::ReadAccessDeniedError
    else
      unless (self.writeaccess.include?(user) || !writeaccess)
        raise Serve::WriteAccessDeniedError
      end
    end
  end

  def self.repo_path_for(hash)
    "#{Pathname.expand_path("~")}/#{hash[:owner]}/#{hash[:name]}"
  end

  def self.create_empty_git_repo(path)
    FileUtils.mkdir_p(path)
    Dir.chdir(path)
    system("git init --bare")
  end

  def self.delete_git_repo(path)
    FileUtils.rm_rf(path)
  end

  def self.create(hash)
    create_empty_git_repo(repo_path_for(hash))
    repo = super(:name => hash[:name])
    repo.owners << hash[:owner]
    repo.save
    repo
  end

  def self.delete
    delete_git_repo(repo_path_for(hash))
    super
  end
end
