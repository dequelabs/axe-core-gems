# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/a11y/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-a11y"
  spec.version       = Rspec::A11y::VERSION
  spec.authors       = ["Deque Systems, Inc."]
  spec.summary       = %q{TODO: RSpec and Cucumber matchers for use with Deque accessibility testing API.}
  spec.homepage      = "http://www.deque.com/"
  # Setting allowed_push_host to prevent accidental pushes to RubyGems.org: http://guides.rubygems.org/publishing/#serving-your-own-gems
  spec.metadata      = { 'allowed_push_host' => '' }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
