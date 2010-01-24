$LOAD_PATH.unshift("lib", *Dir.glob("vendor/*/lib"))

begin
  require "vendor/big_band/dependencies.rb"
rescue LoadError
end

begin
  load "depgen/depgen.task"
rescue LoadError
  sh "git submodule init"
  sh "git submodule update"
  retry
end

task :setup => "dependencies:vendor:all" do
  load "vendor/big_band/dependencies.rb"
  Rake::Task["dependencies:vendor:all"].invoke
end

if ENV['RUN_CODE_RUN']
  Rake::Task["setup"].invoke
  task :default => :spec
else
  task :default => [:setup, :doc]
end

begin
  require "spec/rake/spectask"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = Dir.glob 'spec/**/*_spec.rb'
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

