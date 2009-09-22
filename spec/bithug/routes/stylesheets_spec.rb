# require_relative "../spec_helper.rb" in ruby 1.9
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

describe Bithug::Routes do
  
  it "returns css for /stylesheets/screen.css" do
    logged_in
    get "/stylesheets/screen.css"
    last_response.should be_ok
    last_response.content_type.should =~ /^text\/css/
  end
  
end