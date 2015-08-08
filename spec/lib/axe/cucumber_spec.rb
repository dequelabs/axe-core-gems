require 'spec_helper'
require 'axe/cucumber'

module Axe
  describe Cucumber do
    subject { described_class }

    its(:configuration) { is_expected.to be_a_kind_of(Axe::Cucumber::Configuration) }

    describe "#configure" do
      it "should yield to #configuration" do
        expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(subject.configuration)
      end
    end

    describe "#page_from" do
      let(:page) { double('page') }

      before :each do
        allow(page).to receive(:execute_script)
        allow(subject.configuration).to receive(:page_from).and_return(page)
      end

      it "should get the world's page from the configuration" do
        subject.page_from(:world)
        expect(subject.configuration).to have_received(:page_from).with(:world)
      end
    end
  end
end
