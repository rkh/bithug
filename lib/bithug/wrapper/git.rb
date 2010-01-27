require 'fileutils'
require 'bithug'

# The Git class wraps the most common
# git commands  
module Bithug::Wrapper
  class Git
    def initialize(path,remote=nil)
      @path = File.expand_path(File.join(ENV["HOME"], path))
      @remote = expand_remote(remote)
    end

    def init
      unless @remote
        exec("init", "--bare")
      else
        exec("clone", @remote, @path)
      end
    end

    def remove
      FileUtils.rm_rf(@path)
    end

    private
    def chdir(path)
      wd = Dir.pwd
      FileUtils.mkdir_p(path)
      Dir.chdir(path)
      wd
    end

    def exec(command, *args)
      working_directory = chdir(@path)
      system("git #{command} #{args.join(" ")} >> #{File.join(ENV["HOME"], "system.log")} 2>&1")
      chdir(working_directory)
    end

    def expand_remote(remote)
      return remote unless remote
      return remote if remote =~ /^[a-z]{3,4}:\/\//
      return remote if remote =~ /^[a-z]+@/
      File.expand_path(File.join(ENV["HOME"], remote))
    end
  end
end
