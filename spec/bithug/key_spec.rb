require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Key do
  subject { Bithug::Key }

  before(:all) do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
  end

  it "should add a valid key for an existing user" do
  	key = File.read File.expand_path("../../testkey.pub", __FILE__)
    subject.add :user => :valid_user, :name => 'Test' , :key => key
    User.find(:name => "valid_user").keys.should include(key)
  end

  it "shouldn't accept an invalid key" do
  	subject.new(:name => 'Bogus', :key => '123').valid?.should_not be_true
  end

  it "should delete a present key from a user" do
  	user = Bithug::User.find(:name => "valid_user")
    key = user.keys.first
    key.remove(user)
    user.keys.should_not include(key)
  end
end
 