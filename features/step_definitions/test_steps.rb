Given /^I am using (.*?)$/ do |webdriver|
  require 'capybara'
  Capybara.app = A11yTestPage
  self.extend(Capybara::DSL)

  require 'capybara-webkit'
  Capybara.current_driver = :webkit
end

When /^I visit "(.*?)"$/ do |url|
  visit url
end
