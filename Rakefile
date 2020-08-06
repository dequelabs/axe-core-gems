# bootstrap
desc "bootstrap all packages"
task :bootstrap, [:pkg] do |t, args|
  if args[:pkg].nil?
    sh "
    baseDir=$PWD
    for dir in ./packages/*
    do
      cd $dir
      echo export BUNDLER_VERSION=2.1 >> $BASH_ENV
      source $BASH_ENV
      gem install bundler
      bundle install
      cd $baseDir
    done
    "
  else
    pkgDir = "./packages/#{args[:pkg]}"
    sh "cd #{pkgDir} && bundle install"
  end
end

# test
desc "Test all packages"
task :test, [:pkg] do |t, args|
  if args[:pkg].nil?
    sh "
    baseDir=$PWD
    for dir in ./packages/*
    do
      cd $dir
      rake test
      cd $baseDir
    done
    "
  else
    pkgDir = "./packages/#{args[:pkg]}"
    sh "cd #{pkgDir} && rake test"
  end
end

# build
desc "Build all packages"
task :build, [:pkg] do |t, args|
  if args[:pkg].nil?
    sh "
    baseDir=$PWD
    for dir in ./packages/*
    do
      cd $dir
      rake build
      cd $baseDir
    done
    "
  else
    pkgDir = "./packages/#{args[:pkg]}"
    sh "cd #{pkgDir} && rake build"
  end
end

# format
desc "format code in all packages"
task :format, [:pkg] do |t, args|
  if args[:pkg].nil?
    sh "
    baseDir=$PWD
    for dir in ./packages/*
    do
      cd $dir
      rake format
      cd $baseDir
    done
    "
  else
    pkgDir = "./packages/#{args[:pkg]}"
    sh "cd #{pkgDir} && rake format"
  end
end
