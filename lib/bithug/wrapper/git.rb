require 'fileutils'
require 'bithug'

# The Git class wraps the most common
# git commands  
module Bithug::Wrapper
  class Git
    attr_reader :path, :remote

    def initialize(path,remote=nil)
      @path   = path if path.start_with? "/"
      @path ||= (ENV["HOME"] / path).expand_path
      @remote = expand_remote(remote)
    end

    def init
      remote ? exec("clone", "--bare", @remote, @path) : exec("init", "--bare")
    end

    def remove
      FileUtils.rm_rf path
    end

    def rename(new_name)
      new_path = File.join(path.split("/").tap do |p|
        p.pop
        p << new_name
      end)
      File.join(new_path)
      FileUtils.mv(path, new_path)
      @path = new_path
    end

    def log
      splitter = "-"*20 << rand(2**32).to_s << "-"*20 << "\n"
      entries  = exec("log", "--pretty=format:'#{splitter}%aN\n%ae\n%H\n%at\n%s\n'").split(splitter)
      entries.shift
      entries.map do |raw|
        data = raw.split("\n", 5)
        { :author   => data[0], :email => data[1],
          :revision => data[2], :date_time => data[3],
          :message  => data[4].strip }
      end
    end

    def ls(commit_ish = "HEAD")
      exec("ls-tree", "-l", "-r", "-t", commit_ish).lines.inject({}) do |tree, line|
        return tree unless line =~ /[0-9]+ (.*) ([a-z0-9]+) +(-|[0-9]+)\t(.*)/
        type, sha1, size, path = $1, $2, $3, $4
        # note: since starting with tree, item becomes part of tree!
        item = path.split("/").inject(tree) { |subtree, subpath| subtree[subpath] ||= {} }
        item.merge! :revision => sha1, :size => size unless type == "tree"
        tree
      end
    end

    def chdir(path, &block)
      Dir.pwd.tap do
        FileUtils.mkdir_p(path)
        result = Dir.chdir(path, &block)
        return result if block
      end
    end

    def exec(command, *args)
      chdir(path) { %x[git #{command} #{args.join(" ")} 2>&1] }
    end

    def expand_remote(remote)
      return remote if !remote or remote =~ /^[a-z]{3,4}:\/\/|^[a-z]+@/
      File.expand_path(File.join(ENV["HOME"], remote))
    end
  end
end
