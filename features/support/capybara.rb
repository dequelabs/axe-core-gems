require 'capybara'
require 'capybara-webkit'
require 'selenium-webdriver'
require 'capybara/poltergeist'

# register drivers to match the 'browser' step argument

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
