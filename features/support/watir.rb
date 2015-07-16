require 'watir-webdriver'

# module to expose watir's @browser via capybara-like dsl
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
