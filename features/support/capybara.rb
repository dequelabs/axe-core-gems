require_relative 'env'

require 'capybara/cucumber'

Capybara.default_driver = case ENV["BROWSER"].to_sym
                          when :webkit
                            require 'capybara-webkit'
                            :webkit
                          when :poltergeist
                            require 'capybara/poltergeist'
                            :poltergeist
                          else
                            require 'selenium-webdriver'
                            Capybara.register_driver :selenium do |app|
                              Capybara::Selenium::Driver.new(app, :browser => ENV["BROWSER"].to_sym)
                            end
                            :selenium
                          end
