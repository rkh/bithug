require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::User do
  subject { Bithug::User }
  
  USERNAME = "followed_user"
  USERNAME2 = "following_user"
  
  def create_and_login_user(username)
    Ohm.flush
    Bithug::User.login(username)
  end

  before(:all) do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({USERNAME => BCrypt::Password.create(USERNAME).to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    Ohm.flush
  end

  it "should not be saveable without a name" do
    subject.create.save.should be_false
  end

  it "shouldn't authenticate bogus usernames" do
    subject.authenticate("bogus_user", "chunky bacon").should be_false
  end

  it "should authenticate a local user if local auth is on" do
    subject.authenticate(USERNAME, USERNAME).should be_true
  end

  it "should create a user on login" do
    subject.find(:name => USERNAME).each do |item|
      item.delete
    end
    subject.find(:name => USERNAME).should be_empty
    subject.login(USERNAME).should_not be_nil
    subject.find(:name => USERNAME).should_not be_empty
  end
  
  it "should follow a user correctly" do
    user = create_and_login_user(USERNAME)		
    user2 = create_and_login_user(USERNAME2)
    ###
    user.network.size.should == 0
    user.followers.all.size.should == 0
    user2.network.size.should == 0
    user2.following.all.size.should == 0
    ###
    user2.follow(user)
    user.followers.all.size.should == 1
    user2.following.all.size.should == 1
    user.network.size.should == 1
    pp user.network.first
    user.network.first.following?.should be_true
    user.network.first.active_user.should == user2
    user.network.first.passive_user.should == user
    user2.network.size.should == 1
    user2.network.first.should == user.network.first
    ###
    user2.unfollow(user)
    user2.network.size.should == 2
    user2.following.all.size.should == 0
    user.network.size.should == 2
    user.followers.all.size.should == 0
  end
end
