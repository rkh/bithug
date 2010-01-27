require 'spec_helper'

describe Bithug::Wrapper::GitSvn do
  before(:each) do
    @repo = Bithug::Wrapper::GitSvn.new("testsvn", "svn://bp2009h1srv/bithug_test_svn")
  end

  it "should initialize git repos from svn" do
    @repo.init
    File.directory?(File.join(ENV["HOME"], "testsvn")).should be_true
  end

  it "should be able to rebase" do
    pending
    @repo.pull
  end
end
