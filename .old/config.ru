require "init"
Bithug::Webserver.set :environment, :production
run Bithug::Webserver
