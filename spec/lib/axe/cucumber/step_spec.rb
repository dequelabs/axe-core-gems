require 'spec_helper'
require 'axe/cucumber/step'

module Axe::Cucumber
  describe Step do

    describe "::create_for" do
      before :each do
        allow(Axe::Support).to receive(:page_from)
      end

      it "should create a Step" do
        expect(described_class.create_for :world).to be_a Step
      end

      it "creates the step with the page from the given world" do
        allow(Step).to receive(:new)
        allow(Axe::Support).to receive(:page_from).with(:world).and_return(:page)

        described_class.create_for :world

        expect(Step).to have_received(:new).with(:page)
      end
    end

    pending "#assert_accessibility"

    pending "can be invoked directly in manually-defined step defs (to get arg-parsing OOTB)"

  end
end
