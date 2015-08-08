require 'axe/cucumber/configuration'

module Axe
  module Cucumber
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration if block_given?
    end

    def self.page_from(world)
      configuration.page_from(world)
    end
  end
end
