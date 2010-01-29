require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Repository do
  subject { Bithug::Repository }

  USER_NAME = "valid_user"
  USER_NAME2 = "fork_user"

  def create_and_commit_to_repo(name, user)
    repo = subject.create(:name => name, :owner => user, :vcs => :git)
    repo.commits.size.should == 0
    
    git = Bithug::Wrapper::Git.new("local_commit_#{name}", repo.name)
    git.exec("clone", git.remote, git.path)
    File.open(git.path/"test.txt", 'w') do |f|
      f.write("Some testfile")
    end
    git.exec("add", "test.txt")
    git.exec("commit", "-m", '"test commit"')
    git.exec("push", "origin", "master")
    repo
  end
	
  def create_and_login_user(username)
    Ohm.flush
    Bithug::User.login(username)
  end	
	
  before(:all) do
    @user = create_and_login_user(USER_NAME)
  end

  it "should not be creatable without name or vcs type set" do
    lambda { subject.create(:owner => @user) }.should raise_error(Bithug::ConfigurationError)
  end

  it "be creatable, change it's name properly and add itself to the owner's list" do
    repo_name = "test_repository"
    repo = subject.create(:name => repo_name, :owner => @user, :vcs => :git)
    repo.should_not be_nil
    repo.name.should == USER_NAME/repo_name
    File.exists?(repo.absolute_path).should be_true
    repo.owner.should == @user
    @user.repositories.all.should include repo
  end

  it "should be able to log commits" do
    repo = create_and_commit_to_repo("logrepo", @user)
    repo.commits.size.should == 0
    repo.log_recent_activity
    repo.commits.size.should == 1
    repo.commits.first.message.should == "test commit"
    repo.commits.first.repository.should == repo
  end
  
  it "should be able to fork an existin repo and log that" do
    user2 = create_and_login_user(USER_NAME2)
    repo = create_and_commit_to_repo("repo_to_be_forked", @user)
    user2.forks.size.should == 0

    repo2 = repo.fork(user2)

    repo2.name.should == user2.name/"repo_to_be_forked"
    user2.repositories.all.should include repo2
    repo2.forks.size.should == 1
    user2.forks.size.should == 1
    user2.forks.first.original.should == repo
    user2.forks.first.fork.should == repo2
    user2.forks.first.user.should == user2
  end
  
  it "should allow a user access rights" do
    repo_name = "access_repository"
    repo = subject.create(:name => repo_name, :owner => @user, :vcs => :git)
    user2 = create_and_login_user(USER_NAME2)
    repo.readers.should_not include user2
    repo.writers.should_not include user2
    repo.rights.size.should == 0
    @user.rights.size.should == 0
    user2.rights.size.should == 0
    ###
    @user.grant_access(:user => user2, :repo => repo)
    repo.readers.should include user2
    repo.writers.should_not include user2
    ###
    repo.rights.size.should == 1
    @user.rights.size.should == 1
    user2.rights.size.should == 1
    user2.rights.first.should == @user.rights.first
    user2.rights.first.should == repo.rights.first
    right = repo.rights.first
    right.repository == repo
    right.admin == @user
    right.changed_user == user2
    right.access_granted?.should be_true
    right.writeaccess_granted?.should be_false
    ###
    @user.grant_access(:user => user2, :repo => repo, :access => :w)
    repo.readers.should include user2
    repo.writers.should include user2
    ###
    @user.revoke_access(:user => user2, :repo => repo)
    repo.readers.should include user2
    repo.writers.should_not include user2
    ###
    repo.rights.size.should == 3
    @user.rights.size.should == 3
    user2.rights.size.should == 3
    ###
    @user.revoke_access(:user => user2, :repo => repo, :access => :r)
    repo.readers.all.should_not include user2
    repo.writers.all.should_not include user2
  end
end
