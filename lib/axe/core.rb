require 'pathname'
require 'rubygems'

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
      axe_lib.read
    end

    private

    def axe_lib
      gem_root + 'node_modules/axe-core/axe.min.js'
    end

    def gem_root
      Pathname.new Gem::Specification.find_by_name('axe-matchers').gem_dir
    end

    def wrap_driver(driver)
      ::WebDriverScriptAdapter::ExecuteAsyncScriptAdapter.wrap driver
    end
  end
end
