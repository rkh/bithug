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

      def path(name=nil)
	current_user + "/" + (name || params[:name]).to_s
      end

      def repository(name=nil)
	name ||= path
	repo = Repository.find(:name, path).first
	unless repo
	  redirect "/error/404"
	else
	  repo
	end
      end

      def hostname
	(ENV["HOSTNAME"] || %x["hostname"]).strip
      end

      def writers
	repository.writeaccess.all << current_user
      end

      def readers
	repository.readaccess.all - writers
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
      manager.add_repository(reponame)
      redirect "/repositories/#{path(reponame)}"
    end

    get "/repositories/:username/:name/?" do
      haml :"repositories/view"
    end 

    post "/repositories/:username/:name/?" do

      repository.readaccess.clear
      repository.writeaccess.clear
      params["post"]["readers"].delete(" ").split(",").each do |reader|
	 repository.grant_readaccess(reader)
      end

      params["post"]["writers"].delete(" ").split(",").each do |writer|
	 repository.grant_writeaccess(writer)
      end
      redirect request.path_info
    end 

    put "/repositories/:username/:name/edit/?" do
      "modify a repo"
    end

    delete "/repositories/:username/:name/delete/?" do
      "remove a repo"
    end

  end
end
