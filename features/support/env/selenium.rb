require_relative '../env'
require 'selenium-webdriver'

Before do
  @browser = Selenium::WebDriver.for $browser

  # expose #visit method ala Capybara
  define_singleton_method :visit do |url|
    @browser.navigate.to url
  end
end

After do
  @browser.quit
end
