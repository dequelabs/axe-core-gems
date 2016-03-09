require 'axe/configuration'

module Axe
  class FindsPage
    WEBDRIVER_NAMES = [ :page, :browser, :driver, :webdriver ]

    class << self
      alias :in :new
    end

    def initialize(world)
      @world = world
      @ifnone = -> { raise "A page/browser/webdriver must be configured" }
    end

    def page
      from_configuration || implicit or @ifnone.call
    end

    private

    def configuration
      Axe::Configuration.instance
    end

    def from_configuration
      if configuration.page.is_a?(String) || configuration.page.is_a?(Symbol)
        from_world(configuration.page)
      else
        configuration.page
      end
    end

    def implicit
      WEBDRIVER_NAMES.map(&method(:from_world)).drop_while(&:nil?).first
    end

    def from_world(name)
      via_method(name) || via_ivar(name)
    end

    def via_method(name)
      if @world.respond_to?(name)
        @world.__send__(name)
      end
    end

    def via_ivar(name)
      # ensure leading '@'
      name = name.to_s.sub(/^([^@])/, '@\1').to_sym

      if @world.instance_variables.include?(name)
        @world.instance_variable_get(name)
      end
    end
  end
end
