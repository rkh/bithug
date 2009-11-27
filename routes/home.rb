module Bithug
  class Routes < Sinatra::Base

    def manager
      AccessManager.new(current_user)
    end


    get '/' do      
      redirect "/#{current_user}"
    end

    get '/:username/?' do      
      haml :home, {}, :user => User.find(:name, params[:username]).first,
	 :repositories => (Repository.find(:owner, params[:username]) || []),
	 :writeable_repositories => Repository.writeable_repos_for_user(params[:username]),
	 :readable_repositories => Repository.readable_repos_for_user(params[:username]),
	 :following => (User.find(:name, current_user).first.following.include? params[:username])
    end

    post "/:username/?" do
      require 'pp'; pp params
      if params["post"]["key"] 
	new_key = params["post"]["key"]
        manager.add_key(new_key)
      end
      if params["post"]["follow"]
	user = User.find(:name, current_user).first
	user.following << params[:username]
	user.save
	pp user.following
      end
      if params["post"]["unfollow"]
	user = User.find(:name, current_user).first
	user.following.delete(params[:username])
	user.save
	pp user.following
      end
      redirect request.path_info
    end

  end
end
