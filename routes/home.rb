module Project
  class Routes < Monk::Glue

    get '/' do
      haml :home
    end

  end
end