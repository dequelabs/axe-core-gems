# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'axe/version'

Gem::Specification.new do |spec|
  spec.name          = "axe-matchers"
  spec.version       = Axe::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MPL-2.0"
  spec.authors       = ["Deque Systems, Inc."]
  spec.homepage      = "http://www.deque.com/"
  spec.summary       = "Matchers (ala RSpec, MiniTest) and Cucumber step definitions wrapping the aXe accessibility testing tool"

  # Setting allowed_push_host to prevent accidental pushes to RubyGems.org: http://guides.rubygems.org/publishing/#serving-your-own-gems
  if (Gem::Specification.method_defined? :metadata) then
    spec.metadata      = { 'allowed_push_host' => '' }
  end

  spec.files         = Dir.glob('lib/**/*') + %w[ node_modules/axe-core/axe.min.js LICENSE README.md ]
  spec.require_path  = 'lib'

  spec.add_dependency             'rspec', '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'capybara-webkit'
  spec.add_development_dependency 'poltergeist'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'watir-webdriver'
  spec.add_development_dependency 'rspec_junit_formatter'
end
