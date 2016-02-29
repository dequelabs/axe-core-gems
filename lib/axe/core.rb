require 'pathname'
require 'rubygems'

require 'axe/loader'
require 'axe/page'

module Axe
  class Core
    JS_NAME = "axe"

    def initialize(page)
      @page = Page.new page
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

  end
end
