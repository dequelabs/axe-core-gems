# coding: utf-8
Gem::Specification.new do |spec|
  spec.name = "axe-core-selenium"
  spec.version = "0.0.1"
  spec.summary = "Selenium webdriver injected with Axe"
  spec.authors = ["Deque Systems"]

  spec.platform = Gem::Platform::RUBY

  spec.require_path = "lib"

  spec.add_dependency "dumb_delegator"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "selenium-webdriver"
end
