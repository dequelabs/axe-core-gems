# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'axe/version'

Gem::Specification.new do |spec|
  spec.name     = "axe-matchers"
  spec.version  = Axe::VERSION
  spec.license  = "MPL-2.0"
  spec.authors  = ["Deque Systems, Inc."]
  spec.homepage = "http://www.deque.com/"
  spec.summary  = "Matchers (ala RSpec, MiniTest) and Cucumber step definitions wrapping the aXe accessibility testing tool"

  spec.platform                  = Gem::Platform::RUBY
  spec.required_ruby_version     = ">= 1.9.3"
  spec.required_rubygems_version = ">= 1.3.6"

  spec.files         = Dir.glob('lib/**/*') + %w[ node_modules/axe-core/axe.min.js LICENSE README.md ]
  spec.require_path  = 'lib'

  spec.add_dependency 'dumb_delegator', '~> 0.8.0'
  spec.add_dependency 'virtus', '~> 1.0.5'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'cucumber', '~> 1.3.18'
  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.2'
  spec.add_development_dependency 'sinatra', '~> 1.4.5'

  # drivers
  spec.add_development_dependency 'capybara', '~> 2.4.4'
  spec.add_development_dependency 'capybara-webkit', '~> 1.3.1'
  spec.add_development_dependency 'poltergeist', '~> 1.6.0'
  spec.add_development_dependency 'selenium-webdriver', '~> 2.46.2'
  spec.add_development_dependency 'watir-webdriver', '~> 0.8.0'
end
