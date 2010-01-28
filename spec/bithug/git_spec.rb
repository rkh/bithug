require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Wrapper::Git do
  before(:each) do
    @repo = Bithug::Wrapper::Git.new("testrepo")
  end

  it "should initialize git repos" do
    @repo.init
    File.directory?(File.join(ENV["HOME"], "testrepo")).should be_true
  end

  it "should clone the testrepo" do
    repo = Bithug::Wrapper::Git.new("pullrepo", "testrepo")
    repo.init
    File.directory?(File.join(ENV["HOME"], "pullrepo")).should be_true
  end
end
