require 'selenium-webdriver'

# module to expose selenium's @browser via capybara-like dsl
module Selenium
  module DSL
    def visit(url)
      @browser.navigate.to url
    end

    def quit
      @browser.quit
    end
  end
end
