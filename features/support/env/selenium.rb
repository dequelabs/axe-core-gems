require_relative '../env'
require 'selenium-webdriver'

Before do
  @page = Selenium::WebDriver.for $browser

  # expose #visit method ala Capybara
  define_singleton_method :visit do |url|
    @page.navigate.to url
  end
end

After do
  @page.quit
end
