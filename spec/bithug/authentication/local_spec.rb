# require_relative "../spec_helper.rb" in ruby 1.9
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))
require "bithug/authentication/local"
require "bithug/authentication_spec"

describe Bithug::Authentication::Local do
  subject { Bithug::Authentication::Local.new :file => root_path("spec", "user.yml") }
  it_should_behave_like "Authentication"
end 