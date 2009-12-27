module Bithug
  class Routes < Sinatra::Base
  
    helpers do
      def current_user
        User.find(:name => params[:username]).first
      end
    end

    get '/' do
      redirect "/#{current_user}" 
    end

    get '/:username/?' do
      user = current_user
      haml :home, {}, 
          :user => user,
          :repositories => user.repositories,
          :writeable_repositories => Repository.writeable_repos(user),
          :readable_repositories => Repository.readable_repos(user),
          :following => current_user.following.include?(user)
    end

    post "/:username/?" do
      if params["post"]["key"]
        Key.add(:user => current_user, 
                :name => params["post"]["name"],
                :value => params["post"]["key"])
      elsif params["post"]["follow"]
        user = current_user
        user.following << params[:username]
        user.save
	  elsif params["post"]["unfollow"]
	    user = current_user
        user.following.delete(params[:username])
        user.save
      end
      redirect request.path_info
    end
  end
end
