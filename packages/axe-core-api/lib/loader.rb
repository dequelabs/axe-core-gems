require_relative "./axe/configuration"
require_relative "./hooks"

module Common
  class Loader
    def initialize(page, lib)
      @page = page
      @lib = lib
    end

    def call(source)
      @page.execute_script source
      Common::Hooks.run_after_load @lib
      load_into_iframes(source) unless Axe::Configuration.instance.skip_iframes
    end

    private

    def load_into_iframes(source)
      @page.find_frames.each do |iframe|
        @page.within_frame(iframe) { call source }
      end
    end
  end
end
