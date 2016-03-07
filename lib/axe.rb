require 'axe/configuration'
require 'axe/version'

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
