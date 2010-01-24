module Bithug::Git
  module Repository
    include ServiceHelper

    def create_repository
      super if vcs.to_s != "git"
      git = Bithug::Git.new(absolute_path)
      git.init
    end

    def remove_repository
      super if vcs.to_s != "git"
      git = Bithug::Git.new(absolute_path)
      git.remove
    end

    def absolute_path
      "#{Pathname.expand_path("~")}/#{name}"
    end
  end
end
