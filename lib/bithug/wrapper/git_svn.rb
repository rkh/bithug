# GitSvn wraps the particularities of 
# the git-svn package, so that it can 
# be used like a "normal" git repository
#
# TODO: Conflict handling with git-svn
# is a little difficult: Try to work 
# around that
require 'uri'

module Bithug::Wrapper
  class GitSvn < Git
    def initialize(path, remote, user=nil)
      @path = File.expand_path(File.join(ENV["HOME"], path))
      @remote = remote 
      @user = user
      validate
    end

    def init
      user_switch = @user
      user_switch &&= "--user #{user}"
      exec("svn", "clone", user_switch, remote, path)
    end

    def pull
      exec("svn", "rebase")
    end

    def push
      raise RuntimeError, "Tried to push to a SVN remote!"
    end

    private
      def validate
        unless %w(svn+ssh svn http https).include? URI.parse(@remote).scheme then
          raise RuntimeError, "No valid SVN remote passed"
        end
      end
  end
end
