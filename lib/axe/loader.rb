require 'axe'

module Axe
  class Loader
    def initialize(page, lib)
      @page = page
      @lib = lib
    end

    def call
      @page.execute_script @lib.source unless already_loaded?
      Axe.configuration.run_after_load_hook @lib
      load_into_iframes
    end

    private

    def already_loaded?
      @page.evaluate_script @lib.already_loaded?
    end

    def load_into_iframes
      iframes.each do |iframe|
        @page.within_frame(iframe) { call }
      end
    end

    def iframes
      if @page.respond_to?(:all)
        # capybara: all(<tag>) but also seems to support all(:tag_name, <tag>)
        # selenium: aliases all to find_elements
        @page.all(:tag_name, "iframe")
      elsif @page.respond_to?(:elements)
        # watir: also supports #iframes
        @page.elements(:tag_name, "iframe")
      else
        # selenium: find_elements(:tag_name, <tag>); aliased as all
        @page.find_elements(:tag_name, "iframe")
      end
    end
  end
end
