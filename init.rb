# Setting up the path
ROOT_DIR = File.expand_path File.dirname(__FILE__)
$LOAD_PATH.unshift("lib", *Dir.glob(File.expand_path("vendor/*/lib", ROOT_DIR)))

require "bithug/webserver"
require "config"

Bithug::Webserver.configure do |app|
  app.app_file = __FILE__
  Ohm.connect
  app.run! if $0 == __FILE__
end
