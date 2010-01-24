require "bithug"
require "sinatra/big_band"

module Bithug
  class Webserver < Sinatra::BigBand
    
    helpers do
    end
    
    get "/" do
      "hello"
    end
    
  end
end