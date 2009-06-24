require 'grit'
require 'erubis'

class  Gitosis

  CONFIG_TEMPLATE = <<-EOS
    [gitosis <%= name %>]
    writable = <%= name %>
    members = <%= members %>

  EOS

  include Grit

  # Optionally initialize with non-standard 
  # gitosis-admin path
  def initialize path=ENV["HOME"]+"/gitosis-admin/"
    @path = path
    @conffile = @path+"/gitosis.conf"
    @repo = Repo.new(@path)
  end

  # dump an array of users with their keys into
  # properly named key files, so that gitosis can
  # add them
  def dump_users users
    users.each do |u|
      keyfile = @path+"keydir/"+u.username
      File.open(keyfile, 'w') do |f|
        u.keys.each do |k|
          f << k
        end
      end
      @repo.add(keyfile)
    end
    commit_and_push
  end

  # dump an array of repositories with associated 
  # member info into the config file
  def dump_repos repos
      File.open(@conffile, 'w') do |f|
        f << "[gitosis]\n\n"+
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
