module Bithug::Git
  module Repository
    include Bithug::ServiceHelper

    def create_repository
      super if vcs.to_s != "git"
      wrapper.init
    end

    def remove_repository
      super if vcs.to_s != "git"
      wrapper.remove
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
      Bithug::Wrapper::Git.new(absolute_path)
    end

    def absolute_path
      "#{File.expand_path("~")}/#{name}"
    end
  end
end
