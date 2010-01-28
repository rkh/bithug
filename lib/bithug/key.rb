require 'bithug'
require 'fileutils'

class Bithug::Key < Ohm::Model
  KEYS_FILE = File.expand_path ".ssh/authorized_keys", ENV["HOME"]
  AUTHORIZED_KEYS_OPTIONS = 'command="bithug-serve USER",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty '
  
  unless KEYS_FILE.file_exists?
    FileUtils::Verbose.mkdir_p(KEYS_FILE.dirname) unless KEYS_FILE.dirname.file_exists?
    File.open(KEYS_FILE, 'w') { }
  end

  attribute :name
  attribute :value
  index :value

  def remove(user)
    user.ssh_keys.delete(key)
    user.save
    # BUG: SANITIZE USERNAME FOR REGEX!
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

    def add(params = {})
      user = params.delete(:user)
      key = create(params)
      key.validate
      key.save
      pp user.ssh_keys
      user.ssh_keys << key
      pp user.ssh_keys
      user.save
      File.open(KEYS_FILE, 'a+') do |f|
        f << AUTHORIZED_KEYS_OPTIONS.gsub("USER", user.name) << key.value << "\n"
      end
      key
    end
    
    def validate
      raise Net::SSH::Exception, "public key at #{filename} is not valid" unless valid?
    end
    
    def valid?
      data = value
  	  type, blob = data.split(/ /)
  	  return false if blob.nil?
  	  blob = blob.unpack("m*").first
  	  reader = Net::SSH::Buffer.new(blob)
  	  reader.read_key
  	  true
  	end
  	
  end
end
