require 'spec_helper'
require 'axe/core'

module Axe
  describe Core do

    its(:source) { should start_with "/*! aXe" }

  end
end
