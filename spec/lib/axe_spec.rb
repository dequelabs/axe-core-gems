require 'spec_helper'
require 'axe'

describe Axe do
  subject { described_class }

  its(:configuration) { is_expected.to be_a_kind_of(Axe::Configuration) }

  describe "#configure" do
    it "should yield to #configuration" do
      expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(subject.configuration)
    end
  end
end
