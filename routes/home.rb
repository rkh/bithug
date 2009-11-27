module Bithug
  class Routes < Sinatra::Base

    def manager
      AccessManager.new(current_user)
    end


    get '/' do      
      haml :home, {}, :user => User.find(:name, current_user).first,
	 :repositories => (Repository.find(:owner, current_user) || []),
	 :writeable_repositories => Repository.writeable_repos_for_user(current_user),
	 :readable_repositories => Repository.readable_repos_for_user(current_user)
    end

    get '/:username/?' do      
      haml :home, {}, :user => User.find(:name, params[:username]).first,
	 :repositories => (Repository.find(:owner, params[:username]) || [])
    end

    post "/" do
      new_key = params["post"]["key"]
      manager.add_key(new_key)
      redirect "/"
    end

  end
end
