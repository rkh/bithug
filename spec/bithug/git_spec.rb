require File.expand_path('../../spec_helper', __FILE__)

describe Bithug::Wrapper::Git do
  before(:each) do
    @repo = Bithug::Wrapper::Git.new("testrepo")
  end

  it "should initialize git repos" do
    @repo.init
    File.directory?(File.join(ENV["HOME"], "testrepo")).should be_true
  end

  it "should clone the testrepo" do
    repo = Bithug::Wrapper::Git.new("pullrepo", "testrepo")
    repo.init
    File.directory?(File.join(ENV["HOME"], "pullrepo")).should be_true
  end

  it "should read logs from the testrepo" do
    repo = Bithug::Wrapper::Git.new("commitrepo", "testrepo")
    repo.exec("clone", repo.remote, repo.path)
    File.open(repo.path / "test.txt", 'w') do |f|
      f.write("Some testfile")
    end
    repo.exec("add", "test.txt")
    repo.exec("commit", "-m", '"test commit"')
    repo.log.size.should == 1
    repo.log.first[:message].should == "test commit"
  end
end
