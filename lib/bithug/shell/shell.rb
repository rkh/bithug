require 'bithug'
require 'exceptions'
require 'fileutils'

# When git executes via ssh, it sets the environment
# variable SSH_ORIGINAL_COMMAND to:
#   git-upload-pack/git upload-pack for pull
#   git-receive-pack/git receive-pack for push
# So this is basically the git-user's shell on the server
class Bithug::Shell
  @@read_command = /^git[ |-]upload-pack/
  @@write_command = /^git[ |-]receive-pack/

  def initialize(username) 
    @user = User.find(:name => username).first
    if ENV["SSH_ORIGINAL_COMMAND"] =~ /(#{@@read_command}|#{@@write_command}) (.*)/
      @command, @repository = $1, $2
      @repository.gsub!("'", "") # Git quotes the path, so unquote that
      @writeaccess = (@command =~ @@write_command)
    else
      raise "What do you think I am? A shell? I can only be used through git!"
    end
  end

  def run
    unless repo = Repository.find(:name, @repository).first
      raise Bithug::UnknownRepositoryError, "Could not find a repository named #{@repository}" 
    end
    repo.check_access_rights(@user, @writeaccess)
    exec(@command, File.expand_path("~") / @repository)
    repo.log_recent_activity(@user)
  end
end
