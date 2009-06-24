require 'pathname'
$LOAD_PATH << Pathname("./lib").expand_path.to_s << Dir.glob(Pathname("./vendor/*/lib").expand_path)

require 'sinatra'
require 'haml'

get("/") { "Hello World!" }