$LOAD_PATH.unshift("lib", *Dir.glob("vendor/*/lib"))

load "depgen/depgen.task"

begin

  require "spec/rake/spectask"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = Dir.glob 'spec/**/*_spec.rb'
  end

  require "big_band/integration/rake"
  include BigBand::Integration::Rake
  RoutesTask.new { |t| t.source = "lib/**/*.rb" }

  require "yard"
  require "big_band/integration/yard"
  YARD::Rake::YardocTask.new("doc") do |t|
    t.options = %w[--main README.rdoc --backtrace]
  end
  
  task :default => :spec

rescue LoadError
  $stderr.puts "please install dependencies"
end
