require 'pathname'
require 'rubygems'

module Axe
  class JavaScriptLibrary

    def inject_into(page)
      page.execute source
    end

    def source
      axe_lib.read
    end

    private

    def axe_lib
      gem_root + 'node_modules/axe-core/axe.min.js'
    end

    def gem_root
      Pathname.new Gem::Specification.find_by_name('rspec-axe').gem_dir
    end

  end
end
