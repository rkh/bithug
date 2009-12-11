require 'git'

# GitSvn wraps the particularities of 
# the git-svn package, so that it can 
# be used like a "normal" git repository
#
# TODO: Conflict handling with git-svn
# is a little difficult: Try to work 
# around that
class GitSvn < Git
  def initialize(user,remote)
    @user = user
    @remote = remote
    user &&= "--user #{user}"
    exec("svn", "clone", user, remote)
  end

  def pull
    exec("svn", "rebase")
  end

  def push
    raise RuntimeError, "Tried to push to a SVN remote!"
  end
end
