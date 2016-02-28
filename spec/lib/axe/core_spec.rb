require 'spec_helper'
require 'axe/core'

module Axe
  describe Core do
    subject(:core) { described_class.new(page) }
    let(:page) { spy('page') }

    its(:source) { should start_with "/*! aXe" }

    describe "initialize" do
      pending "should load itself into the given page"
    end
  end
end
