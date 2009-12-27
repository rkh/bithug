module Bithug
  class Routes < Sinatra::Base
  
    helpers do
      def user
        User.find(:name => params[:username]).first
      end
    end

    get '/' do
      redirect "/#{current_user}" 
    end

    get '/:username/?' do
      uzer = user
      haml :home, {}, 
          :user => uzer,
          :repositories => uzer.repositories,
          :writeable_repositories => Repository.writeable_repos(uzer),
          :readable_repositories => Repository.readable_repos(uzer),
          :following => this_user.following.include?(uzer)
    end

    post "/:username/?" do
      if params["post"]["key"]
        Key.add(:user => user, 
                :name => params["post"]["name"],
                :value => params["post"]["key"])
      elsif params["post"]["follow"]
        uzer = user
        uzer.following << params[:username]
        uzer.save
	  elsif params["post"]["unfollow"]
	    uzer = user
        uzer.following.delete(params[:username])
        uzer.save
      end
      redirect request.path_info
    end
  end
end
