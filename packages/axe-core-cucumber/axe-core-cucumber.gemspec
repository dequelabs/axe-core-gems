# coding: utf-8

require_relative "../../version"

Gem::Specification.new do |spec|
  spec.name = "axe-core-cucumber"
  spec.summary = "Cucumber step definitions for Axe"

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
                          LICENSE
                          README.md
                        ]

  spec.add_dependency "dumb_delegator"
  spec.add_dependency "virtus"
  spec.add_dependency "axe-core-api"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rspec-its", "~> 1.2"
end
