# coding: utf-8

require_relative "../../version"

Gem::Specification.new do |spec|
  spec.name = "axe-core-api"
  spec.summary = "Axe API utility methods"

  spec.version = AxeCoreGems::VERSION
  spec.authors = ["Deque Systems"]
  spec.email = ["helpdesk@deque.com"]
  spec.homepage = "https://www.deque.com"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dequelabs/axe-core-gems"
  spec.metadata["bug_tracker_uri"] = "https://github.com/dequelabs/axe-core-gems/issues"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.require_paths = ["lib"]
  spec.files = Dir.glob %w[
                          lib/**/*
                          node_modules/axe-core/axe.min.js
                          LICENSE
                          README.md
                        ]

  spec.add_dependency "dumb_delegator"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"

  spec.add_development_dependency "capybara"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "watir"
  spec.add_development_dependency "virtus"
end
