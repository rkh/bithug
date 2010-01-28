require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Key do
  subject { Bithug::Key }

  before(:all) do
    user_file = File.join(ENV["HOME"], "users.yaml")
    File.open(user_file, 'w') do |f| 
      f.write({"valid_user" => BCrypt::Password.create("valid_user").to_s}.to_yaml)
    end
    Bithug::Local.setup(:file => user_file)
    @value = File.read File.expand_path("../../testkey.pub", __FILE__)
  end
  
  before :each do
    @user = Bithug::User.find(:name => "valid_user").first
  end

  it "should add a valid key for an existing user" do
    subject.add :user => @user, :name => 'Test' , :value => @value
    @user.ssh_keys.should include(key)
  end

  it "shouldn't accept an invalid key" do
  	subject.new(:name => 'Bogus', :value => '123').valid?.should be_false
  end

  it "should delete a present key from a user" do
    subject.add :user => @user, :name => 'Test' , :value => @value
    key = @user.ssh_keys.first
    key.remove(@user)
    @user.ssh_keys.should_not include(key)
  end
end
 