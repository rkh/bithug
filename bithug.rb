require 'pathname'
$LOAD_PATH << Pathname("./lib").expand.to_s << Dir.glob(Pathname("./vendor/*/lib").expand)

require 'sinatra'
require 'haml'

get("/") { "Hello World!" }