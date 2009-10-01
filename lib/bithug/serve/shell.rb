# When git executes via ssh, it sets the environment
# variable SSH_ORIGINAL_COMMAND to:
#   git-upload-pack/git upload-pack for pull
#   git-receive-pack/git receive-pack for push
# So this is basically the git-user's shell on the server

class Shell
  @@read_command = Regexp.new "git[ |-]upload-pack"
  @@write_command = Regexp.new "git[ |-]receive-pack"

  def initialize(username) 
    unless @user = User.find(:username, username).first
      raise Serve::UnknownUserError
    end
    ENV["SSH_ORIGINAL_COMMAND"] =~ /(git[-| ]upload-pack) (.*)/
    @command = $1
    @repository = $2
    @writeaccess = ((@@write_command =~ @command) == 0)
  end

  def check_access_rights(repo)
    ### TODO: Move this to the Repository model
    unless repo.readaccess.includes(@user)
      raise Serve::ReadAccessDeniedError
    else
      unless (repo.writeaccess.includes(@user) || !@writeaccess)
        raise Serve::WriteAccessDeniedError
      end
    end
  end

  def run
    unless repo = Repository.find(:name, @repository).first 
      raise Serve::UnknownRepositoryError
    end
    repo.check_access_rights(@user, @writeaccess) 
    Dir.chdir(Pathname.expand_path("~"))
    exit(system("git shell -c #{@command} #{@repository}"))
  end
end

# Run with first argument as user name like this:
#   Shell.new(ARGV[0]).run
