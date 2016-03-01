require 'spec_helper'
require 'axe/core'

module Axe
  describe Core do
    subject(:core) { described_class.new(page) }
    let(:page) { spy('page') }

    its(:source) { should start_with "/*! aXe" }

    describe "initialize" do
      it "should inject the axe-core lib" do
        core # trigger initialize
        expect(page).to have_received(:execute_script).with(a_string_starting_with ("/*! aXe"))
      end
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
