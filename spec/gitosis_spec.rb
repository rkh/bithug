require File.dirname(__FILE__) + '/spec_helper'

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

  it "creates proper key files" do
    @gitosis.dump_users [create_dummy_users[0]]
    keyfiles = Dir[@keydir+"*"]
    lines = File.readlines(keyfiles.first)
    lines[0].should == "1stKey"
    lines[1].should == "2ndKey"
  end

  it "creates one keyfile for each user with the username" do
    @gitosis.dump_users create_dummy_users
    keyfiles = Dir[@keydir+"*"]
    keyfiles.size.should == 3
    keyfiles.first.should == @keydir+"user1.pub"
  end  

  it "creates entries for each repo in the config file" do
    @gitosis.dump_repos create_dummy_repos
    lines = File.readlines(@gitdir+"/gitosis.conf")
    lines.size.should == 4*3+2 # 3 repo-entries and 2 header-lines
    lines.first.should == "[gitosis]"
  end

  it "creates proper entries for a repo (with formatting, too)" do
    @gitosis.dump_repos [create_dummy_repos[1]]
    lines = File.readlines(@gitdir+"/gitosis.conf")
    lines.include?("    [group repo1]").should == true
    lines.include?("    writable = repo1").should == true
    lines.include?("    members = u1 u2").should == true
  end

  it "pushes the repository after each action" do
    @mock_repo.should_receive(:commit_all).at_least(:twice)
    @mock_repo.should_receive(:push).at_least(:twice)
    @gitosis.dump_repos create_dummy_repos
    @gitosis.dump_users create_dummy_users
  end
end
