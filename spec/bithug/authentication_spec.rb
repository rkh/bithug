# require_relative "../spec_helper.rb" in ruby 1.9
require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper.rb"))

share_examples_for "Authentication" do

  it("responds to authenticate") { should respond_to(:authenticate) }
  it("responds to register") { should respond_to(:register) }

  it "allowes authentication for a registered user" do
    result = subject.register "foo", "bar"
    [true, false].should include(result)
    subject.authenticate("foo", "bar").should be_true if result
  end

end