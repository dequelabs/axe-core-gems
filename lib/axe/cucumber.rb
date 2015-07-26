require 'axe/cucumber/configuration'

module Axe
  module Cucumber
    def self.configuration
      @configuration ||= Axe::Cucumber::Configuration.new
    end

    def self.configure
      yield configuration if block_given?
    end

    def self.page(world)
      configuration.page_from(world).tap do |page|
        raise WebDriverError, "Configured page must implement #execute_script"  unless page.respond_to?(:execute_script)
      end
    end

    class WebDriverError < TypeError; end
  end
end
