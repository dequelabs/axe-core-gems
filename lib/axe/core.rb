require 'pathname'

require 'webdriver_script_adapter/execute_async_script_adapter'
require 'webdriver_script_adapter/frame_adapter'
require 'webdriver_script_adapter/query_selector_adapter'

require 'axe/loader'

module Axe
  class Core
    JS_NAME = "axe"

    def initialize(page)
      @page = wrap_driver page
      Loader.new(@page, self).call
    end

    def call(callable)
      callable.call(@page)
    end

    def source
      Pathname.new(Axe.configuration.core_jslib_path).read
    end

    def already_loaded?
      <<-JS
        window.#{JS_NAME} &&
        typeof #{JS_NAME}.a11yCheck === 'function'
      JS
    end

    private

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
