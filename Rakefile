$LOAD_PATH.unshift "."
require "init"

def from(*files)
  files.each { |lib| require lib }
  yield
rescue LoadError
  $stderr.puts $!
end

from "rake/clean" do
  task :default => :clobber
  CLEAN.include "**/*.rbc"
  CLOBBER.include "*.gem", "doc", "spec/tmp"
end

from "spec/rake/spectask" do
  task :default => :spec
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = Dir.glob 'spec/**/*_spec.rb'
    t.spec_opts  = %w[-c -f progress --loadby mtime --reverse -b]
  end
end

from "big_band/integration/rake" do
  include BigBand::Integration::Rake
  RoutesTask.new { |t| t.source = "lib/**/*.rb" }
end

from "yard", "big_band/integration/yard" do
  task :default => :doc
  YARD::Rake::YardocTask.new("doc") do |t|
    t.options += %w[--main README.rdoc --backtrace]
    t.after = lambda { `cp -R docs/images/ doc/images/` }
  end
end