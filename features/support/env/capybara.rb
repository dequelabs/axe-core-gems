require_relative '../env'
require 'capybara/cucumber'

# load and select the appropriate browser
Capybara.default_driver = case $browser
                          when :webkit
                            require 'capybara-webkit'
                            :webkit
                          else
                            require 'selenium-webdriver'
                            Capybara.register_driver :selenium do |app|
                              Capybara::Selenium::Driver.new(app, :browser => $browser)
                            end
                            :selenium
                          end

Capybara.default_driver = :selenium_chrome_headless

Before do
  @page = Capybara.current_session
end
