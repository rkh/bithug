require "bithug/user"
require "bithug/repository"
require "bithug/public_key"

module Bithug
  
  def self.environment
    return Sinatra::Base.environment if defined? Sinatra
    unless ENV["ENVIRONMENT"]
      # change to some logger, maybe
      $stderr.puts "Running outside sinatra. ENV[\"ENVIRONMENT\"] not set.",
        "Assuming development."
      return :development
    end
    ENV["ENVIRONMENT"].to_sym
  end
  
end
