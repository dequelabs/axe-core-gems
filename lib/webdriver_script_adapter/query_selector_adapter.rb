require 'dumb_delegator'

module WebDriverScriptAdapter
  class QuerySelectorAdapter < ::DumbDelegator

    def self.wrap(driver)
      # capybara: all(<tag>) but also seems to support all(:tag_name, <tag>)
      # watir: elements(:tag_name); also supports #iframes
      # selenium: find_elements(:tag_name, <tag>); aliased as all

      driver.respond_to?(:find_elements) ? driver : new(driver)
    end

    def find_elements(*args)
      respond_to?(:elements) ? elements(*args) : all(*args)
    end
  end
end
