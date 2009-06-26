require 'pathname'
$LOAD_PATH.unshift Pathname.new(__FILE__).dirname.join("..").expand_path.to_s
require 'config/dependencies'
require 'lib/gitosis-interface.rb'
require 'ostruct'
require 'fakefs'

FakeFS::File.class_eval do 
  define_method :<<  do |content|
    puts(content)
    self
  end
end

