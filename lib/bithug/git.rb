module Bithug::Git
  module Repository
    include Bithug::ServiceHelper

    def create_repository
      super if vcs.to_s != "git"
      git = Bithug::Wrapper::Git.new(absolute_path)
      git.init
    end

    def remove_repository
      super if vcs.to_s != "git"
      git = Bithug::Wrapper::Git.new(absolute_path)
      git.remove
    end

    def absolute_path
      "#{File.expand_path("~")}/#{name}"
    end
  end
end
