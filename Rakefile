require 'rake/clean'
require "bundler/gem_tasks"
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

CLOBBER.include 'pkg', 'node_modules'

# add npm-install as pre-req for build
Rake::Task[:build].enhance [:npm]

###########
# npm
###########

desc "alias for npm:install"
task :npm => 'npm:install'
namespace :npm do
  desc "Install npm dependencies"
  task :install do
    sh "npm install"
  end

  desc "Update npm dependencies to latest version allowed by package.json"
  task :update do
    sh "npm update"
  end

  desc "Upgrade axe-core dependency to latest version available, overwriting package.json"
  task :upgrade do
    sh "npm install --save axe-core@latest"
  end

  desc "Display currently-installed and latest-available versions of axe-core lib"
  task :status do
    sh "npm view axe-core version && npm list axe-core"
  end
end


###########
# RSpec
###########

RSpec::Core::RakeTask.new :spec

namespace :spec do
  desc 'Skip tests tagged as :slow'
  RSpec::Core::RakeTask.new :fast do |t|
    t.rspec_opts = "--tag ~slow"
  end

  desc 'Run RSpec code examples with JUnit formatter'
  RSpec::Core::RakeTask.new :ci do |t|
    t.rspec_opts = "--format RspecJunitFormatter --out results/rspec.xml"
  end
end


###########
# Cucumber
###########

Cucumber::Rake::Task.new :cucumber

namespace :cucumber do
  desc "Run Cucumber features with each driver & browser"
  task :all => %w[ capybara selenium watir ]

  desc "Run Cucumber features with each headless browser"
  task :headless => %w[ selenium:chrome:headless capybara:webkit ]

  desc "Run Cucumber features with Capybara driving each browser"
  task :capybara => %w[ capybara:firefox capybara:chrome capybara:safari capybara:webkit ]

  desc "Run Cucumber features with Selenium driving each browser"
  task :selenium => %w[ selenium:firefox selenium:chrome selenium:safari ]

  desc "Run Cucumber features with Watir driving each browser"
  task :watir => %w[ watir:firefox watir:chrome watir:safari ]

  desc "Run Cucumber features with Firefox under each driver"
  task :firefox => %w[ capybara:firefox selenium:firefox watir:firefox ]

  desc "Run Cucumber features with Chrome under each driver"
  task :chrome => %w[ capybara:chrome selenium:chrome watir:chrome ]

  desc "Run Cucumber features with Safari under each driver"
  task :safari => %w[ capybara:safari selenium:safari watir:safari ]


  Cucumber::Rake::Task.new 'ci', 'Run Cucumber features and save results in junit xml' do |t| t.cucumber_opts = "-p capybara -p chrome --format junit --out results/cucumber/" end

  Cucumber::Rake::Task.new 'capybara:webkit',         'Run Cucumber features with Capybara driving Webkit'            do |t| t.cucumber_opts = "-p capybara -p webkit" end
  Cucumber::Rake::Task.new 'capybara:firefox',        'Run Cucumber features with Capybara driving Firefox'           do |t| t.cucumber_opts = "-p capybara -p firefox" end
  Cucumber::Rake::Task.new 'capybara:chrome',         'Run Cucumber features with Capybara driving Chrome'            do |t| t.cucumber_opts = "-p capybara -p chrome" end
  Cucumber::Rake::Task.new 'capybara:headless',       'Run Cucumber features with Capybara driving headless Chrome'   do |t| t.cucumber_opts = "-p capybara -p chrome-headless" end
  Cucumber::Rake::Task.new 'capybara:safari',         'Run Cucumber features with Capybara driving Safari'            do |t| t.cucumber_opts = "-p capybara -p safari" end

  Cucumber::Rake::Task.new 'selenium:firefox',    'Run Cucumber features with Selenium driving Firefox'   do |t| t.cucumber_opts = "-p selenium -p firefox" end
  Cucumber::Rake::Task.new 'selenium:chrome',     'Run Cucumber features with Selenium driving Chrome'    do |t| t.cucumber_opts = "-p selenium -p chrome" end
  Cucumber::Rake::Task.new 'selenium:safari',     'Run Cucumber features with Selenium driving Safari'    do |t| t.cucumber_opts = "-p selenium -p safari" end

  Cucumber::Rake::Task.new 'watir:firefox',    'Run Cucumber features with Watir driving Firefox'   do |t| t.cucumber_opts = "-p watir -p firefox" end
  Cucumber::Rake::Task.new 'watir:chrome',     'Run Cucumber features with Watir driving Chrome'    do |t| t.cucumber_opts = "-p watir -p chrome" end
  Cucumber::Rake::Task.new 'watir:safari',     'Run Cucumber features with Watir driving Safari'    do |t| t.cucumber_opts = "-p watir -p safari" end
end
