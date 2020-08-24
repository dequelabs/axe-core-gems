# bootstrap
desc "bootstrap all packages"
task :bootstrap, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle install' #{args[:pkg]}"
  sh "bash ./scripts/run-cmd.sh 'npm install' 'axe-core-api'" 
end

# test
desc "Unit test all packages"
task :test_unit, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle exec rake test_unit' #{args[:pkg]}"
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

# pre publish
desc "publish all packages"
task :publish, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'bundle exec rake publish' #{args[:pkg]}"
end
