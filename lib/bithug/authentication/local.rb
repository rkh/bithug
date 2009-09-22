require 'bcrypt'
require 'yaml'

module Bithug
  module Authentication

    # This agent authenticates against the 
    # local database
    class Local

      def with_lock(exclusive = false, thread_safe = true, &block)
        if thread_safe
          if defined? Thread and Thread.list.size > 1
            require "thread"
            @mutex ||= Mutex.new
            @mutex.synchronize { with_lock(exclusive, false, &block) }
          else
            with_lock(exclusive, false, &block)
          end
        else
          mode = exclusive ? "w" : "r"
          File.open(@file, mode) do |f|
            f.flock(exclusive ? File::LOCK_EX : File::LOCK_SH)
            result = yield f
            f.flock File::LOCK_UN
            result
          end
        end
      end
      
      def users
        reload unless @users
        @users
      end
      
      def outdated?
        @mtime.nil? or File.mtime(@file) > @mtime
      end
      
      def reload
        with_lock do |file|
          @mtime = file.mtime
          @users = YAML.load(file)
        end
      end
      
      def store
        with_lock(true) do |file|
          file << users.to_yaml
          @mtime = file.mtime
        end
      end
      
      def initialize(options = {})
        @file = File.expand_path(options["file"] || "config/user.yml")
        File.open(@file, "w") { |f| f.write({}.to_yaml) } unless File.exist? @file
      end

      def authenticate(username, password)
        reload if outdated?
        hashed = users[username]
        hashed && BCrypt::Password.new(hashed) == password
      end

      def register(username, password)
        reload if outdated?
        users[username] = BCrypt::Password.create(password).to_s
        store
      end

    end

  end
end
