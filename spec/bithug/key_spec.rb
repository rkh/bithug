require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Key do
  subject { Bithug::Key }

  before :all do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    Ohm.flush
    @user = Bithug::User.login("valid_user")
    @value = File.read File.expand_path("../../testkey.pub", __FILE__)
  end

  it "should add a valid key for an existing user" do
    Bithug::Key.all.size.should == 0
    key = subject.add(:user => @user, :name => 'Test' , :value => @value)
    key.should_not be_nil
    key.value.should == @value
    key.name.should == "Test"
    Bithug::Key.all.size.should == 1
    key.save.should be_true
    key.should be_valid
    @user.ssh_keys.first.should == key
  end

  it "shouldn't accept an invalid key" do
    pending
    subject.add(:user => @user, :name => 'Bogus', :value => '123').valid?.should be_false
  end

  it "should delete a present key from a user" do
    key = subject.add(:user => @user, :name => 'Test' , :value => @value)
    @user.ssh_keys.all.should include(key)
    key.remove(@user)
    @user.ssh_keys.all.should_not include(key)
  end

end
