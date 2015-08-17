require 'capybara/rspec'
require 'axe/matchers'

require 'rspec/core'
RSpec.configure do |c|
  c.include Axe::Matchers
end
