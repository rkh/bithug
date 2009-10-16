module Bithug
  class Routes < Sinatra::Base

    helpers do
      def owner?
        current_user == params[:username]
      end

      def deny!
        redirect request.path_info.split("/")[0..-2].join("/")
      end

      def manager
        AccessManager.new(current_user)
      end

      def path
	current_user+"/"+params[:name]
      end

      def hostname
	(ENV["HOSTNAME"] || %x["hostname"]).strip
      end

      def writers
	Repository.find(:name, path).first.writeaccess.all.collect do |w|
	  w.name
	end << current_user
      end

      def readers
	Repository.find(:name, path).first.readaccess.all.collect do |r|
	  r.name
	end
      end
    end

    get "/repositories/?" do
      "list of repositories you have access to"
    end

    get "/repositories/new/?" do
       haml :"repositories/new"
    end

    post "/repositories/new/?" do
      reponame = params["post"]["name"]
      manager.add_repository(params["name"])
      redirect "/repositories/#{reponame}"
    end

    get "/repositories/:name/?" do
      haml :"repositories/view"
    end 

    put "/repositories/:name/?" do
      "modify a repo"
    end

    delete "/repositories/:name/?" do
      "remove a repo"
    end

  end
end
