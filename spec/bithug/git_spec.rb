require 'spec_helper'

describe Bithug::Wrapper::Git do
  before(:each) do
    repo = Bithug::Wrapper::Git.new("testrepo")
    repo.init
  end

  it "should initialize git repos" do
    File.directory?(File.join(ENV["HOME"], "testrepo")).should be_true
  end

  it "should clone the testrepo" do
    repo = Bithug::Wrapper::Git.new("pullrepo", "testrepo")
    repo.init
    File.directory?(File.join(ENV["HOME"], "pullrepo")).should be_true
  end
end
