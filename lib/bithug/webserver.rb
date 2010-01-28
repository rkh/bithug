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

    get "/" do
      "Hello #{current_user.name}"
    end

  end
end
