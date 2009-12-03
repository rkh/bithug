class GitSvn < Git
  def init(user=nil)
    user ||= "--user"
    exec("svn", "clone")
  end

  def pull
    exec("svn", "rebase")
  end

  def push
    exec("svn", "dcommit")
  end
end
