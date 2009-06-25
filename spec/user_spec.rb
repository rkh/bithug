require File.dirname(__FILE__) + '/spec_helper'

describe Bithug::User do
  before do
    @user = Bithug::User.new
  end

  it "has a name" do
    @user.should.respond_to?(:name)
    @user.name.should.is_a?(String)
  end

  it "has some public keys" do
    @user.should.respond_to?(:keys)
    @user.keys.should.is_a?(Array) 
  end
end
