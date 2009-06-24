require 'spec_helper'
require 'fakefs'
include Grit

describe Gitosis do
  before do
    @gitdir = "gitosis-admin"
    @keydir = "gitosis-admin/keydir"
    @mock_repo = mock('repo').as_null_object
    @gitosis = Gitosis.new("gitosis-admin")
    Library.add @gitdir
    Library.add @keydir
    Repo.should_receive(:new).
      with("gitosis-admin").
      and_return(@mock_repo)
  end

  def create_dummy_users
    "user1, user2, user3".collect do |n|
      u = OpenStruct.new
      u.username = n
      u.keys = ["1stKey", "2ndKey"]
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
    keyfiles = Dir["gitosis-admin/keydir/*"]

    @gitosis.dump_users users
    keyfiles.size.should == 3
    keyfiles.first.should == "user1.pub"
    File.open(@keydir+keyfiles.first) do |f|
      f.readline.should == "1stKey\n"
      f.readline.should == "2ndKey\n"
    end
    @mock_repo.should_receive(:commit_all).once
    @mock_repo.should_receive(:push).once
  end

  it "creates a proper config file" do
    repos = create_dummy_repos
    @gitosis.dump_repos repos
    File.open(@gitdir+"/gitosis.conf") do |f|
      lines = f.readlines
      lines.size.should == 4*3+2 # 3 repo-entries and 2 header-lines
      lines.first.should == "[gitosis]"
      lines.should.include? "[group repo1]\n"
      lines.should.include? "writable = repo1\n"
      lines.should.include? "member = u1 u2\n"
    end
  end
end
