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
  end

  it "should not be saveable without name or vcs type set" do
    user = Bithug::User.find(:name => USER_NAME).first
    subject.create(:owner => user).save.should raise_error(ConfigurationError)
  end

  it "be creatable, change it's name properly and add itself to the owner's list" do
    repo_name = "test_repository"
    user = Bithug::User.find(:name => USER_NAME).first
    repo = subject.create(:name => repo_name, :owner => user, :vcs => :git)
    repo.should_not be_nil
    repo.name.should == File.join(USER_NAME, repo_name)
    repo.owner.should == user
    user.repositories.should include repo
  end
end
