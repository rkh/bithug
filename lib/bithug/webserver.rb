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

      def gravatar_url(mail, size = 80, default = "monsterid")
        "http://www.gravatar.com/avatar/#{MD5::md5(mail)}?s=#{size}?d=#{default}"
      end
      
      def gravatar(mail, size = 80, default = "monsterid")
        "<img src='#{gravatar_url(mail, size, default)}' alt='' width='#{size}' height='#{size}'>"
      end

      def repo_named(name)
        Bithug::Repository.find(:name => name).first
      end

      def repo
        return unless user
        repo_named(user.name / params[:repository])
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

    post "/:username/add_key" do
      pass unless current_user?
      Bithug::Key.add :user => user, :name => params["post"]["name"], :value => params["post"]["key"]
      redirect "/#{user.name}/settings"
    end

    get "/:username/:repository" do
      pass unless repo
      haml :repository
    end

  end
end
