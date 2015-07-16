# this Axe::Cucumber module definition *ought* to be defined in axe/cucumber
# However, because axe/cucumber requires the step definitions, anything
# that requires axe/cucumber must pull in and extend the entire cucumber dsl.
# That's not desirable for our specs, so we defined Axe::Cucumber.* here,
# so spec/lib/axe/cucumber_spec can just require this file. (instead of
# requiring axe/cucumber and pulling along the step_defs and cucumber dsl with it)
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

module Axe
  module Cucumber
    class Configuration
      attr_accessor :page

      def page_from(world)
        page_from_eval(world) || page || default_page_from(world)
      end

      private

      def page_from_eval(world)
        world.instance_eval "#{page}" if page.is_a?(String) || page.is_a?(Symbol)
      end

      def default_page_from(world)
        world.page if world.respond_to? :page
      end
    end
  end
end
