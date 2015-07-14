Given /^I am using (.*?) to drive (.*?)$/ do |webdriver, browser|
  case webdriver

  when 'capybara'
    require 'capybara'
    Capybara.app = A11yTestPage
    self.extend(Capybara::DSL)

    case browser

    when 'webkit'
      require 'capybara-webkit'
      Capybara.current_driver = :webkit
    end
  end

end

When /^I visit "(.*?)"$/ do |url|
  visit url
end
