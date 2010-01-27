require 'bithug'
require 'bcrypt'
require 'yaml'

module Bithug::Local

  def self.setup(options = {})
    @local_auth_file = File.expand_path(options[:file] || "users.yaml")
    File.open(@local_auth_file, "w") { |f| f.write({}.to_yaml) } unless File.exist? @local_auth_file
  end

  def self.execute_with_lock(exclusive = false, thread_safe = true, &block)
    if thread_safe
      if defined? Thread and Thread.list.size > 1
        require "thread"
        @file_mutex ||= Mutex.new
        @file_mutex.synchronize { execute_with_lock(exclusive, false, &block) }
      else
        execute_with_lock(exclusive, false, &block)
      end
    else
      mode = exclusive ? "w" : "r"
      File.open(@local_auth_file, mode) do |f|
        f.flock(exclusive ? File::LOCK_EX : File::LOCK_SH)
        result = yield f
        f.flock File::LOCK_UN
        result
      end
    end
  end

  def self.local_users
    reload_local_users unless @local_users
    @local_users
  end

  def self.local_users_outdated?
    @file_mtime.nil? or File.mtime(@local_auth_file) > @file_mtime
  end

  def self.reload_local_users
    execute_with_lock do |file|
      @file_mtime = file.mtime
      @local_users = YAML.load(file)
    end
  end

  def self.store_local_users
    execute_with_lock(true) do |file|
      file << local_users.to_yaml
      @file_mtime = file.mtime
    end
  end

  module User
    include ServiceHelper    
    # This agent authenticates against the 
    # local database
    
    class_methods do
      def authenticate(username, password)
        Bithug::Local.reload_local_users if Bithug::Local.local_users_outdated?
        hashed = Bithug::Local.local_users[username]
        (hashed && BCrypt::Password.new(hashed) == password) || super
      end
      
      def register(username, password)
        Bithug::Local.reload_local_users if Bithug::Local.local_users_outdated?
        Bithug::Local.local_users[username] = BCrypt::Password.create(password).to_s
        Bithug::Local.store_local_users
        true
      end
    end
  end

end
 
