# ALL of this only works if PermitUserEnvironment option is set
# Also, you might want to set the default shell for the user to sth
# like /dev/null 

class AccessManager
  require 'fileutils'
  KEYS_FILE = "#{ENV["HOME"]}/.ssh/authorized_keys"

  def add_key(user, key)
    default_options='command="bithug-serve USER",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty '
    File.open(@keys_file, 'a+') do |f|
      f << default_options.gsub("USER", user) << key << "\n"
    end
  end

  def remove_key(user, key)
    # BUG: SANITIZE USERNAME FOR REGEX!

    File.open(@keys_file+Time.now.to_i.to_s, 'w') do |out|
      File.open(@keys_file, 'r+') do |in|
        line = f.readline
        unless line == "environment=\"GITUSER=#{user}\" #{key}"
          out << line
        end
      end
    end

    # BUG: LOCKING HAS TO BE PLACED HERE, OR CHECK IF THE TSTAMP 
    # OF THE OLD FILE CHANGED
    FileUtils.mv(@keys_file+Time.now.to_i.to_s, @keys_file)
  end
end
