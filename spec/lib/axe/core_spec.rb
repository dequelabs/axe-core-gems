require 'spec_helper'
require 'axe/core'

module Axe
  describe Core do
    subject(:core) { described_class.new(page) }
    let(:page) { spy('page', evaluate_script: false) }

    describe "initialize" do
      it "should inject the axe-core lib" do
        described_class.new(page)
        expect(page).to have_received(:execute_script).with(a_string_starting_with ("/*! aXe"))
      end

      context "when axe-core exists in the page" do
        before { allow(page).to receive(:evaluate_script).and_return(true) }

        it "should not inject the axe-core lib" do
          described_class.new(page)
          expect(page).not_to have_received(:execute_script)
        end
      end
    end

    describe "call" do
      let(:run) { spy('run') }

      it "should invoke the callable in the page" do
        core.call(run)

        expect(run).to have_received(:call).with(page)
      end
    end
  end
end
