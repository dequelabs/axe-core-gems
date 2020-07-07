require "rspec/core"

require_relative "../../common/axe/matchers/be_accessible"

RSpec.configure do |config|
  config.include Axe::Matchers
end
