require 'spec_helper'
require 'axe'

describe Axe do
  subject { described_class }

  describe "#configure" do
    it "should yield to #configuration" do
      expect { |stub_block| subject.configure(&stub_block) }.to yield_with_args(Axe::Configuration.instance)
    end
  end
end
