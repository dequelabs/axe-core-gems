# coding: utf-8
Gem::Specification.new do |spec|
  spec.name = "axe-core-selenium"
  spec.version = "0.0.1"
  spec.summary = "Selenium webdriver injected with Axe"
  spec.authors = ["Deque Systems"]

  spec.platform = Gem::Platform::RUBY

  spec.require_path = "lib"
  spec.add_dependency "dumb_delegator", "~> 0.8"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rspec-its", "~> 1.2"

  spec.add_development_dependency "selenium-webdriver", "~> 3.5"
end
