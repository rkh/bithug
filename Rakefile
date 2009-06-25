require 'config/dependencies'
require "spec/rake/spectask"

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = Dir.glob 'spec/**/*_spec.rb'
end

namespace :db do
  desc "AutoMigrate the db (deletes data)"
  task :migrate do
    DataMapper.auto_migrate!
  end
  desc "AutoUpgrade the db (preserves data)"
  task :upgrade do
    DataMapper.auto_upgrade!
  end
end
