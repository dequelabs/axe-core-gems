# coding: utf-8
Gem::Specification.new do |spec|
  spec.name = "axe-core-rspec"
  spec.version = "0.0.1"
  spec.summary = "RSpec custom matchers for axe"
  spec.authors = ["Deque Systems"]
  spec.platform = Gem::Platform::RUBY

  spec.add_dependency "dumb_delegator"
  spec.add_dependency "virtus"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.6"
end
