require 'spec_helper'

describe Bithug::Repository do
  before do
    @repos = Bithug::Repository.new
  end

  it "has a name" do
    @repos.should.respond_to?(:name)
    @repos.name.should.is_a?(String)
  end

  it "has some members" do
    @repos.should.respond_to?(:members)
    @repos.members.should.is_a?(Array)
  end
end
