require "bithug"
require "sinatra/big_band"

module Bithug
  class Webserver < Sinatra::BigBand

    use Rack::Auth::Basic do |username, password|
      if User.authenticate(username, password)
        session["user"] = User.login(username).name
      end
    end
    
    helpers do
      def current_user
        User.find(:name => session["user"]).first
      end
    end
    
    get "/" do
      "Hello #{current_user.name}"
    end
    
  end
end
