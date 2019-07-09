source 'https://rubygems.org'

group :test, :development do
  gem "rubocop"
end

gemspec

# introducing a local group to disallow unnecessary local dependencies installed in circle ci
gem 'chromedriver-helper', :group => :local