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

  describe :map_arguments do

    it "should map an array to a hash" do
      subject.map_arguments([42, 23], :foo, :bar).should == { :foo => 42, :bar => 23 }
    end

    it "should merge in hash values" do
      subject.map_arguments([42, {:bar => 23}], :foo, :bar).should == { :foo => 42, :bar => 23 }
      subject.map_arguments([{ :foo => 42, :bar => 23 }], :foo, :bar).should == { :foo => 42, :bar => 23 }
    end

    it "should be able to handle missing data" do
      subject.map_arguments([42], :foo, :bar).should == { :foo => 42 }
    end

    it "should raise an error when passed too many arguments" do
      lambda { subject.map_arguments([1, 2, 3], :foo, :bar) }.should raise_error
    end
    
    it "should take a hash with defaul values" do
      subject.map_arguments([42], :foo, :bar, :foo => 23, :bar => 23, :blah => 23).should == { :foo => 42, :bar => 23, :blah => 23 }
    end

  end

end
