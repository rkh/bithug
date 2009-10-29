module Bithug
  class Routes < Sinatra::Base

    get '/' do      
      haml :home, {}, :user => current_user
    end

  end
end
