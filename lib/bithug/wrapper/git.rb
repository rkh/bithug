require 'fileutils'
require 'bithug'

# The Git class wraps the most common
# git commands  
module Bithug::Wrapper
  class Git
    attr_reader :path, :remote

    def initialize(path,remote=nil)
      if path.start_with? "/"
        @path = path
      else
        @path = File.expand_path(ENV["HOME"] / path)
      end
      @remote = expand_remote(remote)
    end

    def init
      unless @remote
        exec("init", "--bare")
      else
        exec("clone", "--bare", @remote, @path)
      end
    end

    def remove
      FileUtils.rm_rf(@path)
    end

    def log
      YAML.load("---\n#{exec("log", "--pretty=format:'- :author: %aN\n  :email: %ae\n  :revision: %H\n  :date_time: %aD\n  :message: %s\n'")}") || []
    end

    def chdir(path)
      wd = Dir.pwd
      FileUtils.mkdir_p(path)
      Dir.chdir(path)
      wd
    end

    def exec(command, *args)
      working_directory = chdir(@path)
      output = %x[git #{command} #{args.join(" ")} 2>&1]
      chdir(working_directory)
      output
    end

    def expand_remote(remote)
      return remote unless remote
      return remote if remote =~ /^[a-z]{3,4}:\/\//
      return remote if remote =~ /^[a-z]+@/
      File.expand_path(File.join(ENV["HOME"], remote))
    end
  end
end
