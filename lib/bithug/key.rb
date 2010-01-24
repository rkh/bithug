require 'bithug'
require 'fileutils'

class Bithug::Key 
  include DataMapper::Resource

  KEYS_FILE = "#{ENV["HOME"]}/.ssh/authorized_keys"
  AUTHORIZED_KEYS_OPTIONS = 'command="bithug-serve USER",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty '

  property :id,     Serial
  property :name,   String
  property :value,  String

  def remove(user)
    # BUG: SANITIZE USERNAME FOR REGEX!
    user.keys.remove(key)
    File.open(KEYS_FILE+Time.now.to_i.to_s, 'w') do |out|
      File.open(KEYS_FILE, 'r+') do |infile|
        line = infile.readline
        out << line unless line.end_with?(key)
      end
    end

    # BUG: LOCKING HAS TO BE PLACED HERE, OR CHECK IF THE TSTAMP
    # OF THE OLD FILE CHANGED
    FileUtils.mv(KEYS_FILE+Time.now.to_i.to_s, KEYS_FILE)
  end

  class << self
    # This will create a new key object and write to the 
    # authorized_keys file
    def add(params)
      user = params.delete(:user)
      key = create(params)
      key.save
      user.keys << key
      user.save

      File.open(KEYS_FILE, 'a+') do |f|
        f << AUTHORIZED_KEYS_OPTIONS.gsub("USER", user.name) << key.value << "\n"
      end
    end
  end
end
