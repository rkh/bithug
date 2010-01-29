require "bithug"
require "sinatra/big_band"

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
        user_named(params[:username]) || current_user
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
      
    end

    get("/") { redirect "/#{current_user.name}" }
    get("/:username/?") { haml :home }
    
    get("/:username/follow") do
      current_user.following.add(user)
      current_user.save
      redirect "/#{params[:username]}"
    end

    get("/:username/unfollow") do
      current_user.following.delete(user)
      current_user.save
      redirect "/#{params[:username]}"
    end
    
    get ("/:username/:repository") { haml :"repositories/view" }
 
    post "/:username/?" do
      Bithug::Key.add :user => user, :name => params["post"]["name"], :value => params["post"]["key"] if current_user?
      redirect request.path_info
    end

  end
end
