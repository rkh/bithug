class GitSvn < Git
  def initialize(user,remote)
    @user = user
    @remote = remote
    user &&= "--user #{user}"
    exec("svn", "clone", remote)
  end

  def pull
    exec("svn", "rebase")
  end

  def push
    raise RuntimeError, "Tried to push to a SVN remote!"
  end
end
