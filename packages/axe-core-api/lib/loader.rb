require_relative "./axe/configuration"
require_relative "./axe/core"
require_relative "./hooks"

module Common
  class Loader
    INJECTED = "axeCoreGemsInjected".freeze

    def initialize(page, lib, loaded_top_level: false)
      @page = page
      @lib = lib
      @loaded_top_level = loaded_top_level
    end

    def load_top_level(source)
      @page.execute_script source
      @loaded_top_level = true
      Common::Hooks.run_after_load @lib
    end

    def call(source, is_top_level = true, iframes: true)
      if is_top_level || !injected?
        unless @loaded_top_level and is_top_level
          @page.execute_script source
          mark_injected unless is_top_level
        end
        set_allowed_origins
        Common::Hooks.run_after_load @lib
      end
      load_frames = iframes && !Axe::Configuration.instance.skip_iframes
      load_into_iframes(source) if load_frames
      load_frames
    end

    private

    def injected?
      @page.evaluate_script "window.#{INJECTED} !== undefined && window.#{INJECTED} === window.#{Axe::Core::JS_NAME}"
    end

    def mark_injected
      @page.execute_script "window.#{INJECTED} = window.#{Axe::Core::JS_NAME};"
    end

    def set_allowed_origins
      allowed_origins = "<same_origin>"
      allowed_origins = "<unsafe_all_origins>" if !Axe::Configuration.instance.legacy_mode && !Axe::Core::has_run_partial?(@page)
      @page.execute_script "axe.configure({ allowedOrigins: ['#{allowed_origins}'] });"
    end

    def load_into_iframes(source)
      @page.find_frames.each do |iframe|
        @page.within_frame(iframe) { call source, false }
      end
    end
  end
end
