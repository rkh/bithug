class AccessManager
  require 'fileutils'
  KEYS_FILE = "#{ENV["HOME"]}/.ssh/authorized_keys"

  def initialize(user)
    unless @user = User.find(:username, user).first
      raise Serve::UnknownUserError
    end
  end

  def add_key(key)
    default_options='command="bithug-serve USER",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty '
    File.open(@keys_file, 'a+') do |f|
      f << default_options.gsub("USER", @user.name) << key << "\n"
    end
  end

  def remove_key(key)
    # BUG: SANITIZE USERNAME FOR REGEX!

    File.open(@keys_file+Time.now.to_i.to_s, 'w') do |out|
      File.open(@keys_file, 'r+') do |in|
        line = f.readline
        unless line == "environment=\"GITUSER=#{@user.name}\" #{key}"
          out << line
        end
      end
    end

    # BUG: LOCKING HAS TO BE PLACED HERE, OR CHECK IF THE TSTAMP 
    # OF THE OLD FILE CHANGED
    FileUtils.mv(@keys_file+Time.now.to_i.to_s, @keys_file)
  end

  def add_repository(project_name)
    repo = Repository.create(name: project_name, owner: @user)    
  end

  def remove_repository(project_name)
    unless repo = Repository.find(:name, project_name)
      raise Serve::UnknownRepositoryError
    end
    unless repo.owners.include?(@user) 
      raise Serve::AdminAccessDeniedError
    end
    repo.delete 
  end
end
