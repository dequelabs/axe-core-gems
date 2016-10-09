require 'axe/configuration'
require 'axe/hooks'

module Axe
  class Loader
    def initialize(page, lib)
      @page = page
      @lib = lib
    end

    def call(source)
      @page.execute_script source
      Axe::Hooks.run_after_load @lib
      load_into_iframes(source) unless Axe::Configuration.instance.skip_iframes
    end

    private

    def load_into_iframes(source)
      iframes.each do |iframe|
        @page.within_frame(iframe) { call source }
      end
    end

    def iframes
      @page.find_elements(:css, "iframe")
    end
  end
end
