$LOAD_PATH.unshift("lib", *Dir.glob("vendor/*/lib"))

require "rake/clean"
CLEAN.include "**/*.rbc"
CLOBBER.include "*.gem", "doc", "spec/tmp"

task :default do
  sh "git submodule init -q && git submodule update"
  Rake::Task["spec"].invoke
end

begin
  require "spec/rake/spectask"
  task :spec => %w[spec:bithug spec:big_band spec:monkey-lib]
  namespace :spec do
    desc "run specs for Bithug"
    Spec::Rake::SpecTask.new('bithug') do |t|
      t.spec_files = Dir.glob 'spec/**/*_spec.rb'
      t.spec_opts = %w[-c -f progress --loadby mtime --reverse -b]
    end
    desc "run specs for BigBand"
    task 'big_band' do |t|
      chdir('vendor/big_band') { sh 'git submodule init && git submodule update && rake spec' }
    end
    desc "run specs for MonkeyLib"
    task 'monkey-lib' do |t|
      chdir('vendor/monkey-lib') { sh 'rake spec' }
    end
  end
rescue LoadError
  $stderr.puts $!
end

begin
  require "big_band/integration/rake"
  include BigBand::Integration::Rake
  RoutesTask.new { |t| t.source = "lib/**/*.rb" }
rescue LoadError
  $stderr.puts $!
end

begin
  require "yard"
  require "big_band/integration/yard"
  YARD::Rake::YardocTask.new("doc") do |t|
    t.options = %w[--main README.rdoc --backtrace]
  end
rescue LoadError
  $stderr.puts $!
end

