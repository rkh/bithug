# This module wraps tracking remote SVN repositories
# On inclusion into another module/class this is put
# in-between (if I understand the semantics correctly)
# thus, Ohm::Model methods will be available on inclusion 
# and this repo type can add an attribute to the model
module Bithug::Svn
  module Repository
    include Bithug::ServiceHelper

    attribute :remote

    def create_repository
      super if vcs.to_s != "svn"
      wrapper.init
    end

    def remove_repository
      super if vcs.to_s != "svn"
      wrapper.remove
    end

    def update_repository
      return if vcs.to_s != "svn"
      wrapper.pull
      log_recent_activity
    end

    def log_recent_activity
      log = wrapper.log.collect do |item|
        CommitInfo.new.tap do
          wrapper.log.each_pair do |k, v|
            c.send("#{k}=".to_sym, v)
          end
        end
      end
      commits.replace((log + commits.all).uniq)
    end

    def wrapper
      Bithug::Wrapper::GitSvn.new(absolute_path, remote)
    end

    def absolute_path
      "#{File.expand_path("~")}/#{name}"
    end
  end
end
