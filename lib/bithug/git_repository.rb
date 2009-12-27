module Bithug::GitRepository
  def create_repository
    super if vcs != "git"
    git = Bithug::Git.new(absolute_path)
    git.init
  end

  def remove_repository
    super if vcs != "git"
    git = Bithug::Git.new(absolute_path)
    git.remove
  end

  private
    def absolute_path
      "#{Pathname.expand_path("~")}/#{name}"
    end
end
