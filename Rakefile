require "rake/clean"
require "bundler/gem_tasks"

CLOBBER.include "pkg", "node_modules"

# add npm-install as pre-req for build
Rake::Task[:build].enhance [:npm]

###########
# npm
###########
desc "alias for npm:install"
task :npm => "npm:install"
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

  desc "Upgrade axe-core dependency to latest prerelease version, overwriting package.json"
  task :next do
    sh "npm install --save axe-core@next"
  end

  desc "Display currently-installed and latest-available versions of axe-core lib"
  task :status do
    sh "npm view axe-core version && npm list axe-core"
  end
end
