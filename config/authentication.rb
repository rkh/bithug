require "bithug/authentication"

module Bithug
  class Routes < Sinatra::Base
    
    configure do
      set :auth_agent, Bithug::Authentication.new(settings["authentication"])
      use Rack::Auth::Basic do |username, password|
        auth_agent.authenticate(username, password)
      end
    end
    
    helpers do
      def current_user
        request.env['REMOTE_USER']
      end
    end
    
  end
end