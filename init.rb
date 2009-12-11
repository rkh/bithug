# Setting up the path
ROOT_DIR = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift("lib", *Dir.glob(File.join(ROOT_DIR, "vendor", "*", "lib")))

require "bithug"
require "ohm"

Bithug.configure do |app|
  app.app_file = __FILE__
  require app.root_path("config", "settings")
  app.root_glob("{config,routes}", "**", "*.rb") { |f| require f }
  Ohm.connect
end
