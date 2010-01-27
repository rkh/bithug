require 'spec_helper'

describe Bithug::Wrapper::GitSvn do
  before(:each) do
    @repo = Bithug::Wrapper::GitSvn.new("svn://")
  end

  it "should initialize git repos from svn" do
    @repo.init
    File.directory?(File.join(ENV["HOME"], "testsvn")).should be_true
  end

  it "should be able to rebase" do
    @repo.pull
  end
end
