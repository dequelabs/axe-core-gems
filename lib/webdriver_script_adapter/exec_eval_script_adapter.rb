require 'dumb_delegator'

module WebDriverScriptAdapter
  # Capybara distinguishes eval from exec
  # (eval is a query, exec is a command)
  # this decorator makes webdriver act like capybara
  class ExecEvalScriptAdapter < ::DumbDelegator

    def self.wrap(driver)
      raise WebDriverError, "WebDriver must respond to #execute_script" unless driver.respond_to? :execute_script
      driver.respond_to?(:evaluate_script) ? driver : new(driver)
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
  end

  class WebDriverError < TypeError; end
end
