require_relative '../env'
require 'capybara/cucumber'

# load and select the appropriate browser
Capybara.default_driver = case $browser
                          when :webkit
                            require 'capybara-webkit'
                            :webkit
                          when :poltergeist
                            require 'capybara/poltergeist'
                            :poltergeist
                          else
                            require 'selenium-webdriver'
                            Capybara.register_driver :selenium do |app|
                              Capybara::Selenium::Driver.new(app, :browser => $browser)
                            end
                            :selenium
                          end

Before do
  @page = Capybara.current_session
end
