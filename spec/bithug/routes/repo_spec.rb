# require_relative "../spec_helper.rb" in ruby 1.9
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

describe Bithug::Routes do
  
  it "responds to #{path}" do
    get "/#{path}"
    last_response.should be_ok
  end
  
  it "responds to #{path}" do
    get "/#{path}"
    last_response.should be_ok
  end
  
  it "responds to #{path}" do
    get "/#{path}"
    last_response.should be_ok
  end
  
end