require 'rake/clean'
require "bundler/gem_tasks"
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

CLOBBER.include 'pkg'

Cucumber::Rake::Task.new(:cucumber)

RSpec::Core::RakeTask.new(:spec)
