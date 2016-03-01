require 'spec_helper'
require 'axe'

describe Axe do
  subject { described_class }

  its(:configuration) { is_expected.to be_a_kind_of(Axe::Configuration) }

  describe "#configure" do
    it "should yield to #configuration" do
      expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(subject.configuration.api)
    end
  end

  describe "#page_from" do
    let(:page) { double('page', execute_script: nil) }

    before :each do
      allow(subject.configuration).to receive(:page_from).and_return(page)
    end

    it "should get the world's page from the configuration" do
      subject.page_from(:world)
      expect(subject.configuration).to have_received(:page_from).with(:world)
    end
  end
end
