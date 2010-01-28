require 'bithug'
require 'fileutils'
require 'net/ssh'

class Bithug::Key < Ohm::Model
  KEYS_FILE = "#{ENV["HOME"]}/.ssh/authorized_keys"
  AUTHORIZED_KEYS_OPTIONS = 'command="bithug-serve USER",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty '

  attribute :name
  attribute :value

  def remove(user)
    # BUG: SANITIZE USERNAME FOR REGEX!
    user.ssh_keys.remove(key)
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
      Net::SSH::Buffer
      key.validate
      key.save
      user.ssh_keys << key
      user.save

      File.open(KEYS_FILE, 'a+') do |f|
        f << AUTHORIZED_KEYS_OPTIONS.gsub("USER", user.name) << key.value << "\n"
      end
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
