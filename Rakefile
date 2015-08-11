require 'rake/clean'
require "bundler/gem_tasks"
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

CLOBBER.include 'pkg', 'node_modules'

# npm

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

desc "alias for npm:install"
task :npm => 'npm:install'

# RSpec

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  RSpec::Core::RakeTask.new(:ci) do |t|
    t.rspec_opts = "--format RspecJunitFormatter --out rspec.xml"
  end
end

# Cucumber

Cucumber::Rake::Task.new(:cucumber)

namespace :cucumber do
  desc "Run Cucumber features with each driver & browser"
  task :all => %w[ capybara selenium watir ]

  desc "Run Cucumber features with each headless browser"
  task :headless => %w[ capybara:webkit capybara:poltergeist phantomjs ]

  desc "Run Cucumber features with Capybara driving each browser"
  task :capybara => %w[ capybara:webkit capybara:poltergeist capybara:firefox capybara:chrome capybara:safari capybara:phantomjs ]

  desc "Run Cucumber features with Selenium driving each browser"
  task :selenium => %w[ selenium:firefox selenium:chrome selenium:safari selenium:phantomjs ]

  desc "Run Cucumber features with Watir driving each browser"
  task :watir => %w[ watir:firefox watir:chrome watir:safari watir:phantomjs ]

  desc "Run Cucumber features with Firefox under each driver"
  task :firefox => %w[ capybara:firefox selenium:firefox watir:firefox ]

  desc "Run Cucumber features with Chrome under each driver"
  task :chrome => %w[ capybara:chrome selenium:chrome watir:chrome ]

  desc "Run Cucumber features with Safari under each driver"
  task :safari => %w[ capybara:safari selenium:safari watir:safari ]

  desc "Run Cucumber features with PhantomJS under each driver"
  task :phantomjs => %w[ capybara:phantomjs selenium:phantomjs watir:phantomjs ]

  Cucumber::Rake::Task.new 'capybara:webkit' do |t| t.cucumber_opts = "-p capybara -p webkit" end
  Cucumber::Rake::Task.new 'capybara:poltergeist' do |t| t.cucumber_opts = "-p capybara -p poltergeist" end
  Cucumber::Rake::Task.new 'capybara:firefox' do |t| t.cucumber_opts = "-p capybara -p firefox" end
  Cucumber::Rake::Task.new 'capybara:chrome' do |t| t.cucumber_opts = "-p capybara -p chrome" end
  Cucumber::Rake::Task.new 'capybara:safari' do |t| t.cucumber_opts = "-p capybara -p safari" end
  Cucumber::Rake::Task.new 'capybara:phantomjs' do |t| t.cucumber_opts = "-p capybara -p phantomjs" end

  Cucumber::Rake::Task.new 'selenium:firefox' do |t| t.cucumber_opts = "-p selenium -p firefox" end
  Cucumber::Rake::Task.new 'selenium:chrome' do |t| t.cucumber_opts = "-p selenium -p chrome" end
  Cucumber::Rake::Task.new 'selenium:safari' do |t| t.cucumber_opts = "-p selenium -p safari" end
  Cucumber::Rake::Task.new 'selenium:phantomjs' do |t| t.cucumber_opts = "-p selenium -p phantomjs" end

  Cucumber::Rake::Task.new 'watir:firefox' do |t| t.cucumber_opts = "-p watir -p firefox" end
  Cucumber::Rake::Task.new 'watir:chrome' do |t| t.cucumber_opts = "-p watir -p chrome" end
  Cucumber::Rake::Task.new 'watir:safari' do |t| t.cucumber_opts = "-p watir -p safari" end
  Cucumber::Rake::Task.new 'watir:phantomjs' do |t| t.cucumber_opts = "-p watir -p phantomjs" end
end
