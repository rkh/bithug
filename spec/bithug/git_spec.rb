require 'spec_helper'

describe Bithug::Wrapper::Git do
  before(:each) do
    repo = Bithug::Wrapper::Git.new("testrepo")
    repo.init
  end

  it "should initialize git repos" do
    File.directory?("testrepo").should be_true
  end

  it "should pull from the testrepo" do
    repo = Bithug::Wrapper::Git.new("pullrepo", "testrepo")
    repo.init
    File.directory?("pullrepo").should be_true
    repo.pull
  end

  it "should push to the testrepo" do
    repo = Bithug::Wrapper::Git.new("pushrepo", "testrepo")
    repo.init
    File.directory?("pushrepo").should be_true
    repo.push
  end
end
