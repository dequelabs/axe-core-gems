require 'spec_helper'
require 'axe/cucumber'

module Axe
  describe Cucumber do
    let(:subject) { described_class }

    its(:configuration) { is_expected.to be_a_kind_of(Axe::Cucumber::Configuration) }

    describe "#configure" do
      it "should yield to #configuration" do
        expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(subject.configuration)
      end
    end

    describe "#build_steps_for" do
      let(:page) { double('page') }
      let(:steps) { double('steps') }

      before :each do
        allow(page).to receive(:execute_script)
        allow(subject.configuration).to receive(:page_from).and_return(page)
        allow(Axe::Cucumber::Steps).to receive(:new).with(page).and_return(steps)
      end

      it "should instantiate Steps with the page from the given Cucumber World" do
        expect(subject.build_steps_for("world")).to eq(steps)
      end

      it "should provide a Cucumber World in which to resolve the page" do
        subject.build_steps_for("world")
        expect(subject.configuration).to have_received(:page_from).with("world")
      end

      it "should ensure the page is webdriver-esque" do
        class << page; undef execute_script end
        expect { subject.build_steps_for("foo") }.to raise_error(Axe::Cucumber::WebDriverError)
      end
    end
  end
end
