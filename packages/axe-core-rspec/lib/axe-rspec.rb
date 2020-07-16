require "rspec/core"

require "axe/matchers/be_accessible"

RSpec.configure do |config|
  config.include Axe::Matchers
end
