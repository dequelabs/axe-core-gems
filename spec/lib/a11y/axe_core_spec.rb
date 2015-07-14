require 'spec_helper'
require 'rspec/a11y/axe_core'

module RSpec::A11y
  describe AxeCore do

    its(:source) { should start_with "/*! aXe" }

  end
end
