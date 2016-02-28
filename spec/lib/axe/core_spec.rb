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

    describe "call" do
      let(:a11y_check) { spy('a11y_check') }

      it "should invoke the callable in the page" do
        core.call(a11y_check)

        expect(a11y_check).to have_received(:call).with(page)
      end
    end
  end
end
