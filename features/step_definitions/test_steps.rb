module Watir
  module DSL
    def page
      @browser
    end

    def visit(url)
      @browser.goto url
    end

    def quit
      @browser.close
    end
  end
end

After do
  quit
end


Given /^I am using (.*?) to drive (.*?)$/ do |webdriver, browser|
  case webdriver

  when 'capybara'
    require 'capybara'
    self.extend(Capybara::DSL)

    case browser

    when 'webkit'
      require 'capybara-webkit'
      Capybara.current_driver = :webkit
    when 'firefox'
      Capybara.current_driver = :selenium
    end

  when 'watir'
    require 'watir-webdriver'
    self.extend(Watir::DSL)

    case browser
    when 'firefox'
      @browser = Watir::Browser.new

    end
  end

end

When /^I visit "(.*?)"$/ do |url|
  visit url
end
