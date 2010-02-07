require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::ConfigDsl do

  subject { Bithug::ConfigDsl.new }

  describe :environment do

    it "should not evaluate the given block, if the passed arguments don't include the current environment" do
      value = 23
      Bithug::ConfigDsl.new(:foo).environment(:bar, :blah) { value = 42 }
      value.should == 23
    end

    it "should evaluate the given block, if the passed arguments include the current environment" do
      value = 23
      Bithug::ConfigDsl.new(:foo).environment(:foo, :bar) { value = 42 }
      value.should == 42
    end

    it "should always return the current environment" do
      Bithug::ConfigDsl.new(:foo).environment(:bar) { value = 42 }.should == :foo
      Bithug::ConfigDsl.new(:bar).environment.should == :bar
    end

    it "should raise an argument if environment is present as argument but no block is given" do
      lambda { Bithug::ConfigDsl.new(:foo).environment(:foo) }.should raise_error(LocalJumpError)
      lambda { Bithug::ConfigDsl.new(:foo).environment(:bar) }.should_not raise_error
    end

  end

end
