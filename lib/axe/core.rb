require 'pathname'

require 'webdriver_script_adapter/execute_async_script_adapter'

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

    private

    def wrap_driver(driver)
      ::WebDriverScriptAdapter::ExecuteAsyncScriptAdapter.wrap driver
    end
  end
end
