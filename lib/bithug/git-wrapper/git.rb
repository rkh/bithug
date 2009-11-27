require 'fileutils'

class Git
  def initialize(path,remote)
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

  private
  def chdir
    FileUtils.mkdir_p(path)
    Dir.chdir(path)
  end

  def exec(command, args)
    chdir(@path)
    system("git #{command} #{args})
  end
end
