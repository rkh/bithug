module Bithug
  class Routes < Sinatra::Base

    helpers do
      def owner?
        current_user == params[:username]
      end

      def deny!
        redirect request.path_info.split("/")[0..-2].join("/")
      end
    end
    
    get '/admin/:repo/?' do
      haml :repo, {}, :owner => owner?
    end

    get '/create_repo/?' do
      haml :repo_create
    end

    get '/delete_repo/?' do
      haml :repo_delete
    end

    get '/:username/:repo/add_committer/?' do
      deny! unless owner?
      haml :repo_add_committer
    end
  end
end
