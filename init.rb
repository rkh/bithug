# Setting up the path
ROOT_DIR = File.expand_path File.dirname(__FILE__)
$LOAD_PATH.unshift("lib")

require "bithug/webserver"
require "config" unless ENV['RACK_ENV'] == 'test'

require "yaml"
JSON = YAML unless defined? JSON

Bithug::Webserver.configure do |app|
  app.app_file = __FILE__
  app.run! if $0 == __FILE__
end
