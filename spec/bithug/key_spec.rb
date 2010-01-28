require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Key do
  subject { Bithug::Key }

  before :all do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    Bithug::User.delete_all
    Bithug::Key.delete_all
    @user = Bithug::User.login("valid_user")
    @value = File.read File.expand_path("../../testkey.pub", __FILE__)
  end

  it "should add a valid key for an existing user" do
    key = subject.add(:user => @user, :name => 'Test' , :value => @value)
    key.should_not be_nil
    Bithug::Key.all.size.should == 1
    @user.ssh_keys.should include(key)
  end

  it "shouldn't accept an invalid key" do
    subject.add(:user => @user, :name => 'Bogus', :value => '123').valid?.should be_false
  end

  it "should delete a present key from a user" do
    key = subject.add(:user => @user, :name => 'Test' , :value => @value)
    @user.ssh_keys.should include(key)
    key.remove(@user)
    @user.ssh_keys.should_not include(key)
  end

end
