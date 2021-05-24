Given(/^I am a visitor$/) do
end

When(/^I visit "(.*?)"$/) do |url|
  @driver.page.visit url
end
