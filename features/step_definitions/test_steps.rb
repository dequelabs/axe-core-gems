# watir/selenium don't auto-close like capybara
After do
  quit if respond_to?(:quit)
end

Transform /^(.*?)$/ do |string|
  string.to_sym
end

Given /^I am using (.*?) to drive (.*?)$/ do |webdriver, browser|
  activate_driver webdriver, browser
end

When /^I visit "(.*?)"$/ do |url|
  visit url
end
