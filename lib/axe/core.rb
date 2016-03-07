require 'webdriver_script_adapter/execute_async_script_adapter'
require 'webdriver_script_adapter/frame_adapter'
require 'webdriver_script_adapter/query_selector_adapter'

require 'axe/configuration'
require 'axe/loader'

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
      Loader.new(@page, self).call(source) unless already_loaded?
    end

    def already_loaded?
      @page.evaluate_script <<-JS
        window.#{JS_NAME} &&
        typeof #{JS_NAME}.a11yCheck === 'function'
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
