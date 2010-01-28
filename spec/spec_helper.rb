require File.expand_path("../../init.rb", __FILE__)

require 'fileutils'
include FileUtils::Verbose

begin
  require "ruby-debug"
rescue LoadError
  def debugger
    warn "could not load ruby-debug"
  end
end

ROOT_DIR = File.expand_path "../..", __FILE__
TEMP_DIR = File.expand_path "../tmp", __FILE__
ENV['RACK_ENV'] = 'test'
ENV['HOME']     = TEMP_DIR 
rm_rf TEMP_DIR
mkdir_p TEMP_DIR

module Bithug
  
  configure do
    Ohm.connect
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
  conf.include Bithug::TestMethods
end
