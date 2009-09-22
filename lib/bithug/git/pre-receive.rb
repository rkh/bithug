
username = ARGV[0]
reponame = ARGV[1]
r = Repo.find(:name, ARGV[0])
exit(r.write_access.includes? username)

