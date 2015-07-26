require 'axe/cucumber/configuration'
require 'axe/cucumber/steps'

module Axe
  module Cucumber
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration if block_given?
    end

    def self.steps
      # evaled against cucumber World
      -> { Axe::Cucumber.build_steps_for(self) }
    end

    def self.build_steps_for(world)
      Steps.new page_from(world)
    end

    private

    def self.page_from(world)
      configuration.page_from(world).tap do |page|
        raise WebDriverError, "Configured page must implement #execute_script"  unless page.respond_to?(:execute_script)
      end
    end

    class WebDriverError < TypeError; end
  end
end
