# Setting up the path
ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR
$LOAD_PATH.unshift("lib", *Dir.glob(File.join(ROOT_DIR, "vendor", "dependencies", "lib")))

require "dependencies"
require "monkey-lib"
require "compass"
require "monk/glue"
require "haml"
require "sass"

module Project   
  class Routes < Monk::Glue
    set :app_file, __FILE__
    set :views, root_path("views")
    use Rack::Session::Cookie
    Dir.glob(root_path("{config,routes}/**/*.rb")) { |f| require f }
    run! if run?  
  end
end
