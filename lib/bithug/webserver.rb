require "bithug"
require "sinatra/big_band"

module Bithug
  class Webserver < Sinatra::BigBand

    enable :sessions

    use Rack::Auth::Basic do |username, password|
      Bithug::User.login(username) if Bithug::User.authenticate(username, password)
    end

    helpers do
      def current_user
        Bithug::User.find(:name => request.env['REMOTE_USER']).first
      end
    end

    get("/") { redirect "/#{current_user.name}" }
    get("/:username/?") { haml :home, {}, :user => Bithug::User.find(:name => params[:username]).first }

    post "/:username/?" do
      user = Bithug::User.find(:name => params[:username]).first
      if params["post"]["key"]
        if user == current_user
          key = Bithug::Key.add :user => user, :name => params["post"]["name"], :value => params["post"]["key"]
        else
          "cannot push key to another user"
        end
      elsif params["post"]["follow"]
        current_user.following << params[:username]
        current_user.save
	    elsif params["post"]["unfollow"]
        current_user.following.delete params[:username]
        current_user.save
      end
      redirect request.path_info
    end

  end
end
