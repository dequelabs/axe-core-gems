require 'pathname'
require 'rubygems'

module Axe
  class Core
    JS_NAME = "axe"

    def inject_into(page)
      page.execute_script source
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
