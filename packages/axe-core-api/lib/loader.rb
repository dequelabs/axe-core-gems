require_relative "./axe/configuration"
require_relative "./axe/core"
require_relative "./hooks"

module Common
  class Loader
    # a frame that blocks scripts skips event listeners and never fires timers, so axe.runPartial would hang in it
    ASSERT_SCRIPTS_RUN = <<-JS
      (function () {
        var ran = false;
        try {
          var target = document.createElement('div');
          target.addEventListener('axe', function () { ran = true; });
          var event = document.createEvent('Event');
          event.initEvent('axe', false, false);
          target.dispatchEvent(event);
        } catch (e) {
          return;
        }
        if (!ran) {
          throw new Error('Frame cannot run scripts');
        }
      })();
    JS

    def initialize(page, lib)
      @page = page
      @lib = lib
      @loaded_top_level = false
    end

    def load_top_level(source)
      @page.execute_script ASSERT_SCRIPTS_RUN + source
      @loaded_top_level = true
      Common::Hooks.run_after_load @lib
    end

    def call(source, is_top_level = true)
      @page.execute_script source unless (@loaded_top_level and is_top_level)
      set_allowed_origins
      Common::Hooks.run_after_load @lib
      load_into_iframes(source) unless Axe::Configuration.instance.skip_iframes
    end

    private

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
