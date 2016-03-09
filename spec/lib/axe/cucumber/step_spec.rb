require 'spec_helper'
require 'axe/cucumber/step'

module Axe::Cucumber
  describe Step do

    describe "::create_for" do
      it "should create a Step" do
        allow(Axe::FindsPage).to receive_message_chain("in.page")
        expect(described_class.create_for :world).to be_a Step
      end

      it "creates the step with the page from the given world" do
        allow(Step).to receive(:new)
        expect(Axe::FindsPage).to receive_message_chain("in.page").and_return(:page)

        described_class.create_for :world

        expect(Step).to have_received(:new).with(:page)
      end
    end

    pending "#assert_accessibility"

    pending "can be invoked directly in manually-defined step defs (to get arg-parsing OOTB)"

  end
end
