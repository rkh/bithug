module Bithug::Git
  module Repository
    include Bithug::ServiceHelper

    def create_repository
      return super if vcs.to_s != "git"
      wrapper.init
    end

    def remove_repository
      return super if vcs.to_s != "git"
      wrapper.remove
    end

    def log_recent_activity(user=nil)
      log = wrapper.log.collect do |item|
        Bithug::LogInfo::CommitInfo.new.tap do |c|
          item.each_pair do |k, v|
            c.send("#{k}=", v)
          end
        end
      end
      (log - commits.all).each do |item|
        item.save
        item.repository = self
        commits.add(item)
        user.commits.add(item) unless user.nil?
      end
    end

    def tree(path_options={})
      commit_ishs = [:revision, :sha1, :branch, :tag, :commit]
      wrapper.ls(commit_ishs.detect {|i| path_options[i]} || "HEAD")
    end

    def wrapper
      return super if vcs.to_s != "git"
      Bithug::Wrapper::Git.new(absolute_path, remote)
    end

    def absolute_path
      "#{File.expand_path("~")}/#{name}"
    end
  end
end
