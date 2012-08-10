# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "nameable"
  gem.homepage    = "https://github.com/chorn/nameable"
  gem.license     = "MIT"
  gem.summary     = %Q{Provides parsing and output of person names.}
  gem.description = %Q{A gem that provides parsing and output of person names.}
  gem.email       = "chorn@chorn.com"
  gem.authors     = ["Chris Horn"]
  gem.files       = FileList['lib/**/*.rb', 'Gemfile*', '[A-Z]*', 'Rakefile', 'spec/*', 'examples/*'].to_a
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

