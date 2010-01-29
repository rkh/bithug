require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Repository do
  subject { Bithug::Repository }

  USER_NAME = "valid_user"

  before(:all) do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({USER_NAME => BCrypt::Password.create(USER_NAME).to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    Ohm.flush
    @user = Bithug::User.login(USER_NAME)
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
    repo_name = "commit_repository"
    repo = subject.create(:name => repo_name, :owner => @user, :vcs => :git)
    repo.commits.size.should == 0
    
    git = Bithug::Wrapper::Git.new("local_commit_repository", repo.name)
    git.exec("clone", git.remote, git.path)
    File.open(git.path/"test.txt", 'w') do |f|
      f.write("Some testfile")
    end
    git.exec("add", "test.txt")
    git.exec("commit", "-m", '"test commit"')
    git.exec("push", "origin", "master")

    repo.commits.size.should == 0
    repo.log_recent_activity
    repo.commits.size.should == 1
    repo.commits.first.message.should == "test commit"
  end
end
