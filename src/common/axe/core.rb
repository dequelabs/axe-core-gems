require_relative "../webdriver_script_adapter/execute_async_script_adapter"
require_relative "../webdriver_script_adapter/frame_adapter"
require_relative "../webdriver_script_adapter/query_selector_adapter"
require_relative "../loader"
require_relative "./configuration"

module Axe
  class Core
    JS_NAME = "axe"

    def initialize(page)
      @page = wrap_driver page
      load_axe_core Axe::Configuration.instance.jslib
    end

    def call(callable)
      callable.call(@page)
    end

    private

    def load_axe_core(source)
      Common::Loader.new(@page, self).call(source) unless already_loaded?
    end

    def already_loaded?
      @page.evaluate_script <<-JS
        window.#{JS_NAME} &&
        typeof #{JS_NAME}.run === 'function'
      JS
    end

    def wrap_driver(driver)
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
