require 'bithug'
require 'bcrypt'
require 'yaml'

module Bithug::Local

  module User
    include ServiceHelper    
    # This agent authenticates against the 
    # local database
    
    def initialize(options = {})
      super
      @local_auth_file = File.expand_path(options["file"] || "config/user.yml")
      File.open(@local_auth_file, "w") { |f| f.write({}.to_yaml) } unless File.exist? @local_auth_file
    end
  
    def execute_with_lock(exclusive = false, thread_safe = true, &block)
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
  
    def local_users
      reload_local_users unless @local_users
      @local_users
    end
  
    def local_users_outdated?
      @file_mtime.nil? or File.mtime(@local_auth_file) > @file_mtime
    end
  
    def reload_local_users
      execute_with_lock do |file|
        @file_mtime = file.mtime
        @local_users = YAML.load(file)
      end
    end
  
    def store_local_users
      execute_with_lock(true) do |file|
        file << local_users.to_yaml
        @file_mtime = file.mtime
      end
    end
    
    class_methods do
      def authenticate(username, password)
        reload_local_users if local_users_outdated?
        hashed = local_users[username]
        hashed && BCrypt::Password.new(hashed) == password || super
      end
      
      def register(username, password)
        reload_local_users if local_users_outdated?
        local_users[username] = BCrypt::Password.create(password).to_s
        store_local_users
        true
      end
    end
  end

end

end
 