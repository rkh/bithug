ENV['RACK_ENV'] = 'test'
require File.expand_path("../../init.rb", __FILE__)
require "fileutils"
require "bithug"
require "spec"

begin
  require "ruby-debug"
rescue LoadError
  def debugger
    warn "could not load ruby-debug"
  end
end

include FileUtils

ROOT_DIR = File.expand_path "../..", __FILE__
TEMP_DIR = File.expand_path "/tmp/bithug_test", __FILE__
ENV['HOME'] = TEMP_DIR 
rm_rf TEMP_DIR
mkdir_p TEMP_DIR
