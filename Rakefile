$LOAD_PATH.unshift("lib", *Dir.glob("vendor/*/lib"))

require "rake/clean"
CLEAN.include "**/*.rbc"
CLOBBER.include "*.gem"

task :default do
  sh "git submodule init -q && git submodule update"
  Rake::Task["spec"].invoke
end

begin
  require "spec/rake/spectask"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = Dir.glob 'spec/**/*_spec.rb'
    t.spec_opts = %w[-c -f progress --loadby mtime --reverse -b]
  end
rescue LoadError
  $stderr.puts "please install rspec"
end

begin
  require "big_band/integration/rake"
  include BigBand::Integration::Rake
  RoutesTask.new { |t| t.source = "lib/**/*.rb" }
rescue LoadError
  $stderr.puts "please install big_band"
end

begin
  require "yard"
  require "big_band/integration/yard"
  YARD::Rake::YardocTask.new("doc") do |t|
    t.options = %w[--main README.rdoc --backtrace]
  end
rescue LoadError
  $stderr.puts "please install big_band and yard"
end

