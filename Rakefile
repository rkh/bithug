require "spec/rake/spectask"

task :environment do
  require 'config/dependencies'
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = Dir.glob 'spec/**/*_spec.rb'
end

namespace :db do
  desc "AutoMigrate the db (deletes data)"
  task(:migrate => :environment) { DataMapper.auto_migrate! }
  desc "AutoUpgrade the db (preserves data)"
  task(:upgrade => :environment) { DataMapper.auto_upgrade! }
end
