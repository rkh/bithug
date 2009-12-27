require 'fileutils'

# The Git class wraps the most common
# git commands  
module Bithug::Wrapper
  class Git
    def initialize(path,remote=nil)
      @path = path
      @remote = remote
    end

    def init
      exec("init", "--bare")
    end

    ["push", "pull"].each do |cmd|
      define_method(cmd) do |args|
        exec(cmd, args.to_s)
      end
    end

    def clone
      init
      pull
    end

    def remove
      FileUtils.rm_rf(@path)
    end

    private
    def chdir
      FileUtils.mkdir_p(@path)
      Dir.chdir(@path)
    end

    def exec(command, args)
      chdir(@path)
      system("git #{command} #{args}")
    end
  end
end
