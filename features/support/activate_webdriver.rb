module ActivateWebDriver

  def activate_driver(webdriver, browser)
    self.__send__(webdriver, browser)
  end

  private

  def capybara(browser)
    self.extend(Capybara::DSL)
    Capybara.current_driver = browser
  end

  def selenium(browser)
    self.extend(Selenium::DSL)
    @browser = Selenium::WebDriver.for browser
  end

  def watir(browser)
    self.extend(Watir::DSL)
    @browser = Watir::Browser.new browser
  end

end

World(ActivateWebDriver)
