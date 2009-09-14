ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "spec"
require "webrat"
require "rack/test"

Webrat.configure { |config| config.mode = :sinatra }

module Project
  module TestMethods
    def app
      Project::Routes
    end
  end
end

Spec::Runner.configure do |conf|
  conf.include Webrat::Methods
  conf.include Rack::Test::Methods
  conf.include Project::TestMethods
end
