# Setting up the path
ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR
$LOAD_PATH.unshift("lib", *Dir.glob(File.join(ROOT_DIR, "vendor", "*", "lib")))

require "monkey-lib"
require "compass"
require "monk/glue"
require "haml"
require "sass"

module Project   
  class Routes < Monk::Glue
    
    # Monk::Glue relies on Main
    ::Main = self
    
    set :app_file, __FILE__
    set :views, root_path("views")
    set :haml, :format => :html5, :escape_html => true
    
    use Rack::Session::Cookie
    enable :sessions
    
    Dir.glob(root_path("{config,routes}/**/*.rb")) { |f| require f }
    run! if run?  
    
  end
end
