require 'fileutils'
ENV['RACK_ENV'] = 'test'

ENV["HOME"] = File.expand_path(File.join(File.dirname(__FILE__), "tmp"))
FileUtils.rm_rf(ENV["HOME"])
FileUtils.mkdir_p(ENV["HOME"])
require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "spec"
require "webrat"
require "rack/test"

Webrat.configure { |config| config.mode = :rack }

module Bithug
  module TestMethods

    def app
      # Bithug::Routes
    end

    def logged_in
      user, password = "user", "password"
      app.auth_agent.register user, password
      basic_auth user, password
    end

    %w[root_path root_glob route_files].each do |m|
      define_method(m) { |*a| # Bithug::Routes.send(m, *a) 
      }
    end

  end
end

Spec::Runner.configure do |conf|
  conf.include Webrat::Methods
  conf.include Rack::Test::Methods
  conf.include Bithug::TestMethods
end
