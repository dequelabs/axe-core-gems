require "rspec"
require "capybara/rspec"
require "axe-rspec"
require "axe-capybara"

AxeCapybara.configure(:chrome) do |c|
end

RSpec.configure do |config|
  config.color = true
end
