require 'rake/clean'
require "bundler/gem_tasks"
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

CLOBBER.include 'pkg', 'node_modules'

Cucumber::Rake::Task.new(:cucumber)

RSpec::Core::RakeTask.new(:spec)

namespace :npm do
  desc "Install npm dependencies"
  task :install do
    sh "npm install --silent"
  end
end
