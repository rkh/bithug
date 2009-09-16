require "spec/rake/spectask"
require "rake/clean"
require "rake/rdoctask"

task :default => :spec
task :test => :spec

namespace :vendor do
  
  def dependencies
    @dep ||= Hash[
      File.read(".gitmodules").scan /\[submodule \"[^\"]+\"\]\n\s*path\s*=\s*vendor\/(.*)\s*url\s*=\s*(.*)/
    ]
  end
  
  def store_dep(file)
    File.open(file, "w") { |f| f.puts yield(dependencies) }
    puts "output stored in #{file}"
  end
  
  desc "store dependencies as yaml"
  task :to_yaml do
    require "yaml"
    store_dep("dependencies.yml") { |d| d.to_yaml }
  end
  
  desc "store dependencies for Dependency library"
  task :to_dep do
    store_dep("dependencies") { |d| d.collect { |e| e.join " " } }
  end
  
  desc "stores dependencies for rip"
  task :to_rip do
    store_dep("deps.rip") { |d| d.values }
  end
  
  desc "commits dependency lists to git"
  task :publish => [:to_yaml, :to_dep, :to_rip] do
    %w(dependencies.yml dependencies deps.rip).each { |f| sh "git add #{f}" }
    sh "git commit -m 'updated dependency lists'"
  end
  
  namespace :install do
    
    desc "installs dependencies as git submodules"
    task :submodules do
      unless dependencies.all? { |name, url| system "git submodule add #{url} vendor/#{name}" }
        sh "git submodule init && git submodule update"
      end
    end
    
    desc "installs gems for dependencies"
    task :gems do
      sh "gem install #{dependencies.join " "}"
    end
  end
  
end

Rake::RDocTask.new("doc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.options += %w[--all --inline-source --line-numbers --main README.rdoc --quiet
    --tab-width 2 --title Project]
  rdoc.rdoc_files.add ['*.{rdoc,rb}', '{config,lib,routes}/**/*.rb']
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = Dir.glob 'spec/**/*_spec.rb'
end