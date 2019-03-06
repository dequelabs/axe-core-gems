# coding: utf-8

Gem::Specification.new do |spec|
  spec.name        = 'axe-matchers'
  spec.version     = '2.3.0'
  spec.license     = 'MPL-2.0'
  spec.authors     = ['Deque Systems', 'Test Double']
  spec.email       = ['helpdesk@deque.com', 'hello@testdouble.com']
  spec.homepage    = 'https://www.deque.com'
  spec.summary     = 'Automated accessibility testing powered by aXe'
  spec.description = <<-DESC
  axe-matchers provides matchers that wrap the axe-core accessibility library.
  The matchers can be used with RSpec, Cucumber and other test tools.
  Cucumber step definitions are also provided.
  DESC

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/dequelabs/axe-matchers/issues',
    'documentation_uri' => 'https://github.com/dequelabs/axe-matchers/blob/master/README.md',
    'source_code_uri'   => 'https://github.com/dequelabs/axe-matchers',
    'wiki_uri'          => 'https://github.com/dequelabs/axe-matchers/wiki'
  }

  spec.platform                  = Gem::Platform::RUBY
  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.6'
  spec.requirements              = 'A WebDriver of some sort. e.g Capybara, Selenium or Watir'

  spec.files        = Dir.glob %w[ lib/**/* node_modules/axe-core/axe.min.js LICENSE README.md ]
  spec.require_path = 'lib'

  spec.add_dependency 'dumb_delegator', '~> 0.8'
  spec.add_dependency 'virtus', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'cucumber', '~> 2.4'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'sinatra', '~> 2.0'
  # drivers
  spec.add_development_dependency 'capybara', '~> 2.15'
  spec.add_development_dependency 'capybara-webkit', '~> 1.14'
  spec.add_development_dependency 'selenium-webdriver', '~> 3.5'
  spec.add_development_dependency 'watir', '~> 6.6'
end
