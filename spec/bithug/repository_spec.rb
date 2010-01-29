require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Repository do
  subject { Bithug::Repository }

  USER_NAME = "valid_user"
  USER_NAME2 = "fork_user"

  def create_and_commit_to_repo(name)
    repo = subject.create(:name => name, :owner => @user, :vcs => :git)
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
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({username => BCrypt::Password.create(username).to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    Ohm.flush
    user = Bithug::User.login(username)
    user
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

  it "should be able to log activity" do
    repo = create_and_commit_to_repo("logrepo")
    repo.commits.size.should == 0
    repo.log_recent_activity
    repo.commits.size.should == 1
    repo.commits.first.message.should == "test commit"
  end
  
  it "should be able to fork an existin repo" do
    @user2 = create_and_login_user(USER_NAME2)
    repo = create_and_commit_to_repo("repo_to_be_forked")
    repo2 = repo.fork(@user2)
    @user2.repositories.all.should include repo2
  end
end
