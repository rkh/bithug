begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  begin
    require "rubygems"
    gem "bundler", ">= 0.9.1"
  rescue LoadError
  end
  require "bundler"
  Bundler.setup
end


$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)