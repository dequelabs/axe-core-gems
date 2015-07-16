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

  desc "Update npm dependencies to latest version allowed by package.json"
  task :update do
    sh "npm update --silent"
  end

  desc "Upgrade axe-core dependency to latest version available, overwriting package.json"
  task :upgrade do
    sh "npm install --silent --save axe-core"
  end
end
