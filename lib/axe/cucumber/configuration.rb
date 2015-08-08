module Axe
  module Cucumber
    class Configuration
      attr_accessor :page

      def page_from(world)
        # TODO raise error if can't be found
        page_from_eval(world) ||
          page ||
          default_page_from(world) ||
          from_ivar(:@page, world) ||
          from_ivar(:@browser, world) ||
          from_ivar(:@driver, world) ||
          from_ivar(:@webdriver, world)
      end

      private

      def page_from_eval(world)
        world.instance_eval "#{page}" if page.is_a?(String) || page.is_a?(Symbol)
      end

      def default_page_from(world)
        world.page if world.respond_to? :page
      end

      def from_ivar(ivar, world)
        self.page = ivar
        page_from_eval(world)
      end
    end
  end
end
