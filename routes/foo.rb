module Project
  class Routes < Monk::Glue

    get 'bar' do
      haml :bar
    end

  end
end