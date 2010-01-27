require 'spec_helper'

describe "User" do
  User = Bithug::User

  before(:all) do
    User.send(:include, Bithug::Local) unless User.ancestors.include? Bithug::Local
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
  end

  it "should not be saveable without a name" do
    User.create.save.should be_false
  end

  it "shouldn't authenticate bogus usernames" do
    User.authenticate("bogus_user", "chunky bacon").should be_false
  end

  it "should authenticate a local user if local auth is on" do
    User.authenticate("valid_user", "valid_user").should be_true
  end

  it "should create a User on login" do
    User.find(:name => "valid_user").should be_empty
    User.login("valid_user").should_not be_empty
    User.find(:name => "valid_user").should_not be_empty
  end 
end
