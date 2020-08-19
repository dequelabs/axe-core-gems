# bootstrap
desc "bootstrap all packages"
task :bootstrap, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'rake bootstrap' #{args[:pkg]}"
end

# test
desc "Test all packages"
task :test, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'rake test' #{args[:pkg]}"
end

# build
desc "Build all packages"
task :build, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'rake build' #{args[:pkg]}"
end

# format
desc "format code in all packages"
task :format, [:pkg] do |t, args|
  sh "bash ./scripts/run-cmd.sh 'rake format' #{args[:pkg]}"
end
