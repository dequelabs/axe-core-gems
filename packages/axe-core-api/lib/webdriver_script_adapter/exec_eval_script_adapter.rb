require 'dumb_delegator'

module WebDriverScriptAdapter
  # Capybara distinguishes eval from exec
  # (eval is a query, exec is a command)
  # this decorator makes webdriver act like capybara
  class ExecEvalScriptAdapter < ::DumbDelegator
    def self.wrap(driver)
      raise WebDriverError, "WebDriver must respond to #execute_script" unless driver.respond_to? :execute_script

      driver.respond_to?(:evaluate_script) ? ExecEvalScriptAdapter2.new(driver) : new(driver)
    end

    # executes script without returning result
    def execute_script(script)
      super
      nil
    end

    # returns result of executing script
    def evaluate_script(script)
      __getobj__.execute_script "return #{script}"
    end

    def execute_script_fixed(script, *args)
      page = __getobj__
      page = page.driver if page.respond_to?("driver")
      page = page.browser if page.respond_to?("browser")
      page.execute_script(script, *args)
    end
  end
  class ExecEvalScriptAdapter2 < ::DumbDelegator
    def execute_script_fixed(script, *args)
      page = __getobj__
      page = page.driver if page.respond_to?("driver")
      page = page.browser if page.respond_to?("browser")
      page.execute_script(script, *args)
    end
  end

  class WebDriverError < TypeError; end
end
