require File.dirname(__FILE__) + '/spec_helper'
require 'fakefs'

describe Gitosis do
  include Grit
  include FakeFS

  before do
    @gitdir = ENV["HOME"]+"/gitosis-admin"
    @keydir = @gitdir+"/keydir/"
    fs = FileSystem
    FileUtils.mkdir_p @keydir
    @mock_repo = mock('repo').as_null_object
    Repo.should_receive(:new).
      with(@gitdir).
      and_return(@mock_repo)
    @gitosis = Gitosis.new(@gitdir)
  end

  def create_dummy_users
    ["user1", "user2", "user3"].collect do |n|
      u = OpenStruct.new
      u.name = n
      u.keys = [OpenStruct.new, OpenStruct.new]
      u.keys[0].content = "1stKey"
      u.keys[1].content = "2ndKey"
      u
    end
  end

  def create_dummy_repos
    3.times.collect do |i|
      r = OpenStruct.new
      r.name = 'repo'+i.to_s
      r.members = ['u'+i.to_s, 'u'+(i+1).to_s]
      r
    end
  end

  # This should nicely dump a key file 
  # for each user, filled with his keys  
  it "creates proper key files" do
    users = create_dummy_users
    @mock_repo.should_receive(:commit_all).once
    @mock_repo.should_receive(:push).once
    @gitosis.dump_users users
    keyfiles = Dir[@keydir+"*"]

    keyfiles.size.should == 3
    keyfiles.first.should == @keydir+"user1.pub"
    lines = File.readlines(keyfiles.first)
    lines[0].should == "1stKey"
    lines[1].should == "2ndKey"
  end

  it "creates a proper config file" do
    repos = create_dummy_repos
    @mock_repo.should_receive(:commit_all).once
    @mock_repo.should_receive(:push).once
    @gitosis.dump_repos repos
    lines = File.readlines(@gitdir+"/gitosis.conf")
    lines.size.should == 4*3+2 # 3 repo-entries and 2 header-lines
    lines.first.should == "[gitosis]"
    lines.include?("    [group repo1]").should == true
    lines.include?("    writable = repo1").should == true
    lines.include?("    members = u1 u2").should == true
  end
end
