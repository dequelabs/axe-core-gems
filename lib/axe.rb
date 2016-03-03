require 'forwardable'
require 'axe/configuration'

module Axe
  class << self
    extend Forwardable
    def_delegator :configuration, :page_from

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration if block_given?
    end
  end
end
