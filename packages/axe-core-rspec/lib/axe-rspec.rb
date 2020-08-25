require "rspec/core"

require "axe/matchers/be_axe_clean"

RSpec.configure do |config|
  config.include Axe::Matchers
end
