# require_relative "../spec_helper.rb" in ruby 1.9
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

describe Bithug::Routes do
  
  it "enables login" do
    app.auth_agent.register "foo", "bar"
    basic_auth "foo", "bar"
    visit "/"
    last_response.should be_ok
    basic_auth "foo", "blah"
    visit "/"
    last_response.should_not be_ok
  end
  
end