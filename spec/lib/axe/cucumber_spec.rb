require 'spec_helper'
require 'axe/cucumber/configuration'

module Axe
  describe Cucumber do
    let(:subject) { described_class }

    its(:configuration) { is_expected.to be_a_kind_of(Axe::Cucumber::Configuration) }

    describe "#configure" do
      it "should yield to #configuration" do
        expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(subject.configuration)
      end
    end

    describe "#page" do
      let(:page) { double('page') }
      before :each do
        allow(page).to receive(:execute_script)
        allow(subject.configuration).to receive(:page_from).and_return(page)
      end

      it "should get the page from the configuration" do
        expect(subject.page("world")).to eq(page)
      end

      it "should provide a Cucumber World in which to resolve the page" do
        subject.page("world")
        expect(subject.configuration).to have_received(:page_from).with("world")
      end

      it "should ensure the page is webdriver-esque" do
        page.unstub(:execute_script)
        expect { subject.page("foo") }.to raise_error(Axe::Cucumber::WebDriverError)
      end
    end
  end
end
