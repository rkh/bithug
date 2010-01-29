# This module wraps tracking remote SVN repositories
# On inclusion into another module/class this is put
# in-between (if I understand the semantics correctly)
# thus, Ohm::Model methods will be available on inclusion 
# and this repo type can add an attribute to the model
module Bithug::Svn
  module Repository
    include Bithug::ServiceHelper
    include Bithug::Git

    def create_repository
      return super if vcs.to_s != "svn"
      unless remote
        raise RuntimeError, "To mirror a svn repository, I need a remote"
      end
      wrapper.init
    end

    def remove_repository
      return super if vcs.to_s != "svn"
      wrapper.remove
    end

    def update_repository
      return if vcs.to_s != "svn"
      wrapper.pull
      log_recent_activity
    end

    def wrapper
      Bithug::Wrapper::GitSvn.new(absolute_path, remote)
    end
  end
end
