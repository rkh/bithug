require 'grit'
require 'erubis'
require 'pathname'
require 'extlib'

class Gitosis

  CONFIG_TEMPLATE = <<-EOS
    [group <%= name %>]
    writable = <%= name %>
    members = <%= members %>
  EOS
  
  DEFAULT_PATH = Pathname(ENV['HOME']) / "gitosis-admin"

  include Grit

  # Optionally initialize with non-standard 
  # gitosis-admin path
  def initialize(path=nil)
    @path = path || DEFAULT_PATH
    @conffile = @path / "gitosis.conf"
    @repo = Repo.new @path.to_s
  end

  # dump an array of users with their keys into
  # properly named key files, so that gitosis can
  # add them
  def dump_users(users)
    users.each do |u|
      keyfile = "#{@path}/keydir/#{u.name}.pub"
      File.open(keyfile, 'w') do |f|
        u.keys.each do |k|
          f << k.content
        end
      end
      @repo.add(keyfile)
    end
    commit_and_push
  end

  # dump an array of repositories with associated 
  # member info into the config file
  def dump_repos(repos)
      File.open(@conffile, 'w') do |f|
        f << "[gitosis]\n\n"
        repos.each do |r|
          f << Erubis::Eruby.new(CONFIG_TEMPLATE).
            result({:name => r.name, 
                    :members => r.members.join(" ")})
        end
      end
      commit_and_push
  end

  # commit pending changes and push to gitosis
  def commit_and_push
    @repo.commit_all("System commit")
    @repo.push
  end
end
