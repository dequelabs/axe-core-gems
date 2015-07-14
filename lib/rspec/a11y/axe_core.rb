require 'pathname'
require 'rubygems'

module RSpec
  module A11y
    class AxeCore

      def source
        axe_lib.read
      end

      private

      def axe_lib
        gem_root + 'node_modules/axe-core/axe.min.js'
      end

      def gem_root
        Pathname.new Gem::Specification.find_by_name('rspec-a11y').gem_dir
      end

    end
  end
end
