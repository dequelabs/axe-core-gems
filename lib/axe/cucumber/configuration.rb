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
