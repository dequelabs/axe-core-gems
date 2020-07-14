require "rspec"
require "capybara/rspec"
require "axe-rspec"
require "axe-capybara"

@page = AxeCapybara.configure("firefox") do |c|
end

RSpec.configure do |config|
  config.color = true
end
