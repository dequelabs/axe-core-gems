# bootstrap
desc "bootstrap all packages"
task :bootstrap, [:pkg] do |t, args|
  if args[:pkg].nil?
    sh "
    baseDir=$PWD
    for dir in ./packages/*
    do
      cd $dir
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
