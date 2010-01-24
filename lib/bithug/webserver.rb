require "bithug"
require "sinatra/big_band"

module Bithug
  class Webserver < Sinatra::BigBand

    enable :sessions

    use Rack::Auth::Basic do |username, password|
      if Bithug::User.authenticate(username, password)
        current_user = Bithug::User.login(username).name
      end
    end
    
    helpers do
      def current_user
        Bithug::User.find(:name => request.env['REMOTE_USER']).first
      end

      def current_user=(user)
	user = user.name unless user.respond_to? :to_str
	session[:user] = user
      end
    end
    
    get "/" do
      "Hello #{current_user.name}"
    end
    
  end
end
