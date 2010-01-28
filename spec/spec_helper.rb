require 'fileutils'
include FileUtils::Verbose

ROOT_DIR = File.expand_path "../..", __FILE__
TEMP_DIR = File.expand_path "../tmp", __FILE__

ENV['RACK_ENV'] = 'test'
ENV['HOME']     = TEMP_DIR 

rm_rf TEMP_DIR
mkdir_p TEMP_DIR

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "bithug"
require "spec"

Ohm.connect
#require "webrat"
#require "rack/test"

#Webrat.configure { |config| config.mode = :rack }

begin
  require "ruby-debug"
rescue LoadError
  def debugger
    $stderr.puts "could not load ruby-debug"
  end
end

module Bithug
  
  configure do
    use :Local
  end
  
  module TestMethods
    def logged_in
      user, password = "user", "password"
      app.auth_agent.register user, password
      basic_auth user, password
    end
  end
  
end

Spec::Runner.configure do |conf|
  #conf.include Webrat::Methods
  #conf.include Rack::Test::Methods
  conf.include Bithug::TestMethods
end
