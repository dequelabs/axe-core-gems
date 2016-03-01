require 'axe'

module Axe
  class Loader
    def initialize(page, lib)
      @page = page
      @lib = lib
    end

    def call
      @page.execute_script @lib.source
      Axe.configuration.run_after_load_hook @lib
    end
  end
end
