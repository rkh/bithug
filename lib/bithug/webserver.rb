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
        repo_named(user.name / params[:repository])
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
      pass unless user
      haml :home
    end

    get "/:username/follow" do
      follow_unfollow { current_user.following.add(user) }
    end

    get "/:username/unfollow" do
      follow_unfollow { current_user.following.delete(user) }
    end

    get "/:username/new" do
      pass unless current_user?
      haml :new_repository
    end

    post "/:username/?" do
      pass unless user
      Bithug::Key.add :user => user, :name => params["post"]["name"], :value => params["post"]["key"] if current_user?
      redirect request.path_info
    end

    get "/:username/:repository" do
      pass unless repo
      haml :repository
    end

  end
end
