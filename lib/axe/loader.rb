module Axe
  class Loader
    def initialize(page, lib)
      @page = page
      @lib = lib
    end

    def call
      @page.execute_script @lib.source
    end
  end
end
