require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::User do
  subject { Bithug::User }

  before(:all) do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
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
    subject.authenticate("valid_user", "valid_user").should be_true
  end

  it "should create a User on login" do
    subject.find(:name => "valid_user").each do |item|
      item.delete
    end
    subject.find(:name => "valid_user").should be_empty
    subject.login("valid_user").should_not be_nil
    subject.find(:name => "valid_user").should_not be_empty
  end 
end
