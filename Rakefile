# bootstrap
desc "bootstrap all packages"
task :bootstrap, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle install' #{args[:pkg]}"
  sh "bash ./scripts/run-cmd.sh 'npm install' 'axe-core-api'" 
end

# test
desc "Test all packages"
task :test, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle exec rake test' #{args[:pkg]}"
end

# build
desc "Build all packages"
task :build, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle exec rake build' #{args[:pkg]}"
end

# format
desc "format code in all packages"
task :format, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle exec rake format' #{args[:pkg]}"
end