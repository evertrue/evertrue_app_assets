require 'bundler/gem_helper'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I lib -r evertrue_app_assets.rb'
end
