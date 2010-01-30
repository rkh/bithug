require "bithug"
require "sinatra/big_band"
require "md5"

module Bithug
  class Webserver < Sinatra::BigBand

    enable :sessions

    use Rack::Auth::Basic do |username, password|
      Bithug::User.login(username) if Bithug::User.authenticate(username, password)
    end

    helpers do

      def user_named(name)
        Bithug::User.find(:name => name).first
      end

      def user
        user_named(params[:username])
      end

      def current_user
        user_named request.env['REMOTE_USER']
      end

      def current_user?
        user == current_user
      end

      def toggle_follow
        "#{"un" if current_user.following? user}follow"
      end

      def gravatar_url(mail, size, default)
        "http://www.gravatar.com/avatar/#{MD5::md5(mail)}?s=#{size}&d=#{default}"
      end

      def gravatar(mail, size = 80, default = "wavatar")
        "<img src='#{gravatar_url(mail, size, default)}' alt='' width='#{size}' height='#{size}'>"
      end

      def repo_named(name)
        Bithug::Repository.find(:name => name).first
      end

      def repo
        return unless user
        repo = repo_named(user.name / params[:repository])
        repo if repo and repo.check_access_rights(current_user)
      rescue Bithug::ReadAccessDeniedError
        nil
      end

      def owned?
        repo.owner == current_user
      end

      def title
        Bithug.title
      end

    end

    def follow_unfollow
      pass unless user
      yield unless current_user?
      current_user.save
      redirect "/#{params[:username]}"
    end

    get("/") { haml :dashboard }

    get "/:username/?" do
      # user.commits.recent(20)
      # user.network.recent
      # user.forks.recent(5)
      # user.rights.recent

      pass unless user
      haml :user
    end

    get("/:username/follow") do
      follow_unfollow { current_user.follow(user) }
    end

    get("/:username/unfollow") do
      follow_unfollow { current_user.unfollow(user) }
    end

    get "/:username/new" do
      pass unless current_user?
      haml :new_repository
    end

    post "/:username/new" do
      pass unless current_user?
      reponame = params["repo_name"]
      vcs = params["vcs"] || "git"
      Repository.create(:name => reponame, :owner => user, :vcs => vcs)
      redirect "/#{user.name}/#{reponame}"
    end

    get "/:username/settings" do
      pass unless current_user?
      haml :settings
    end
    
    get "/:username/delete_key/:id" do
      pass unless current_user?
      key = Bithug::Key[params[:id]]
      key.remove(user) if user.ssh_keys.include? key
      redirect "/#{user.name}/settings"
    end

    post "/:username/add_key" do
      pass unless current_user?
      Bithug::Key.add :user => user, :name => params["name"], :value => params["value"]
      redirect "/#{user.name}/settings"
    end

    get "/:username/:repository/?" do
      pass unless repo
      # repo.tree <- returns a nested hash of the (w)hole repository tree
      haml :repository
    end

    post "/:username/:repository/grant/:read_or_write/:other_username" do
      pass unless repo
      # this will grant the other user read/write access according to the url spec
      pass unless %w(w r).include? params[:read_or_write]
      user.grant_access(:user => params[:other_username], :repo => repo, 
      :access => params[:read_or_write])
    end

    post "/:username/:repository/revoke/:read_or_write/:other_username" do
      pass unless repo
      # this will revoke the other users read/write access according to the url spec 
      # (fails silently if the other user wasn't allowed in the first place)
      pass unless %w(w r).include? params[:read_or_write]
      user.revoke_access(:user => params[:other_username], :repo => repo, 
      :access => params[:read_or_write])
    end

    post "/:username/:repository/create" do
      # this will create a new repo
      # The POST should have a VCS parameter.
      # Optionally it might have a REMOTE parameter, if it does
      # the underlying repo might try to fetch it.
      # SVN requires a remote, it'll raise an error otherwise
      # GIT will try to fork from the remote
      pass unless user == current_user
      Repository.create(:owner => user, :name => params[:repository], 
      :vcs => params["post"]["vcs"], 
      :remote => params["post"]["remote"])
    end

    post "/:username/:repository/fork" do
      pass unless repo
      repo.fork current_user
      redirect "/#{current_user.name}/#{params[:repository]}"
    end

    get "/:username/:repository/:commit_spec" do
      pass unless repo
      repo.tree(params[:commit_spec]) # <- if this isn't a tag, branch, commit (...) then the hash will simply be empty
    end

  end
end
