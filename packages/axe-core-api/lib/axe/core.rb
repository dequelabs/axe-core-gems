require_relative "../webdriver_script_adapter/execute_async_script_adapter"
require_relative "../webdriver_script_adapter/frame_adapter"
require_relative "../webdriver_script_adapter/query_selector_adapter"
require_relative "../loader"
require_relative "./configuration"
require 'timeout'

module Axe
  class Core
    JS_NAME = "axe"

    def initialize(page)
      @page = wrap_driver page
      load_axe_core Axe::Configuration.instance.jslib
    end

    def call(callable)
      if use_run_partial
        callable.analyze_post_43x @page, self
      else
        load_legacy callable
        callable.call @page
      end
    end

    def call_verbatim(callable)
      callable.call @page
    end

    def self.has_run_partial?(page)
      page.evaluate_script <<-JS
          typeof window.axe.runPartial === 'function'
      JS
    end

    private

    def use_run_partial
      Core.has_run_partial?(@page) and not Axe::Configuration.instance.legacy_mode
    end

    def load_axe_core(source)
      @source = source
      loaded = already_loaded?
      @loader = Common::Loader.new(@page, self, loaded_top_level: loaded)
      return if loaded

      begin
        @loading_frames = true
        @loader.load_top_level source
      ensure
        @loading_frames = false
      end
    end

    def load_legacy(callable)
      return if @frames_loaded || @loading_frames

      iframes = !callable.respond_to?(:iframes?) || callable.iframes?
      begin
        @loading_frames = true
        @frames_loaded = @loader.call @source, iframes: iframes
      ensure
        @loading_frames = false
      end
    end

    def already_loaded?
      @page.evaluate_script <<-JS
        window.#{JS_NAME} &&
        typeof #{JS_NAME}.run === 'function'
      JS
    end

    def wrap_driver(driver)
      driver = driver.driver if driver.respond_to? :driver
      ::WebDriverScriptAdapter::QuerySelectorAdapter.wrap(
        ::WebDriverScriptAdapter::FrameAdapter.wrap(
          ::WebDriverScriptAdapter::ExecuteAsyncScriptAdapter.wrap(
            ::WebDriverScriptAdapter::ExecEvalScriptAdapter.wrap(
              driver
            )
          )
        )
      )
    end
  end
end
