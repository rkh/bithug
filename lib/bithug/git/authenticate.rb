# ALL of this only works if PermitUserEnvironment option is set
# Also, you might want to set the default shell for the user to sth
# like /dev/null 

require 'fileutils'
@keys_file = "#{ENV["HOME"]}/.ssh/authorized_keys"

def add_key_to_user(user, key)
  File.open(@keys_file, 'a+') do |f|
    f << "environment=\"GITUSER=#{user}\" " 
      << key 
      << "\n"
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
