module Bithug
  class Routes < Sinatra::Base

    helpers do
      def owner?
        current_user.name == params[:username]
      end

      def deny!
        redirect request.path_info.split("/")[0..-2].join("/")
      end

      def path_to(name=nil)
        current_user + "/" + (name || params[:name]).to_s
      end

      def repository(name=nil)
        name ||= path
        repo = Repository.find(:name => path).first
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
        repository.writers.all << current_user
      end

      def readers
        repository.readers.all - writers
      end
    end

    get "/repositories/?" do
      # Show the user's repositories
      user.repositories
    end

    get "/repositories/new/?" do
       haml :"repositories/new"
    end

    post "/repositories/new/?" do
      reponame = params["post"]["name"]
      vcs = params["post"]["vcs"] || "git"
      Repository.create(:name => reponame, 
                        :owner => current_user,
                        :vcs => vcs)
      redirect "/repositories/#{path_to(reponame)}"
    end

    get "/repositories/:username/:name/?" do
      haml :"repositories/view", {}, 
          :path => "#{params[:username]}/#{params[:name]}"
    end 

    post "/repositories/:username/:name/?" do
      readers = params["post"]["readers"].delete(" ").split(",")
      writers = (params["post"]["readers"].delete(" ").split(",") + readers).uniq
      repository.readers.replace(readers)
      repository.writers.replace(writers)

      redirect request.path_info
    end

    put "/repositories/:username/:name/edit/?" do
      "modify a repo"
    end

    delete "/repositories/:username/:name/?" do
      "remove a repo"
    end
  end
end
