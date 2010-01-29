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

      def gravatar(mail, size = 80, default = "monsterid")
        "http://www.gravatar.com/avatar/#{MD5::md5(mail)}?s=#{size}?d=#{default}"
      end

      def repo_named(name)
        Bithug::Repository.find(:name => name).first
      end

      def repo
        return unless user
        repo = repo_named(user.name / params[:repository])
        # maybe you should check access here ...
        begin
          repo.check_access_rights(current_user)
        rescue ReadAccessDeniedError => e
          return
        end
        repo
      end

    end

    def follow_unfollow
      pass unless user
      yield unless current_user?
      current_user.save
      redirect "/#{params[:username]}"
    end

    get("/") { redirect "/#{current_user.name}" }

    get "/:username/?" do
      # user.commits.recent(20)
      # user.network.recent
      # user.forks.recent(5)
      # user.rights.recent

      pass unless user
      haml :home
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

    get "/:username/settings" do
      pass unless current_user?
      haml :settings
    end

    post "/:username/?" do
      pass unless user
      Bithug::Key.add :user => user, :name => params["post"]["name"], :value => params["post"]["key"] if current_user?
      redirect request.path_info
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
                        :access => params[:read_or_write]
    end

    post "/:username/:repository/revoke/:read_or_write/:other_username" do
      pass unless repo
      # this will revoke the other users read/write access according to the url spec 
      # (fails silently if the other user wasn't allowed in the first place)
      pass unless %w(w r).include? params[:read_or_write]
      user.revoke_access(:user => params[:other_username], :repo => repo, 
                         :access => params[:read_or_write]
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
      # This will fork the repo for the current user 
      repo.fork(current_user)
    end

    get "/:username/:repository/:commit_spec" do
      pass unless repo
      repo.tree(params[:commit_spec]) # <- if this isn't a tag, branch, commit (...) then the hash will simply be empty
    end

  end
end
