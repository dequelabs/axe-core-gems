require 'axe/configuration'

module Axe
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration if block_given?
    end
  end
end
