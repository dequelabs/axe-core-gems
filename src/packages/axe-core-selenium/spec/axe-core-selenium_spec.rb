require "spec_helper"
require "tempfile"

require_relative "../axe-core-selenium"

describe AxeSelenium do
  subject { described_class }

  describe "#configure (defaults)" do
    it "should yield default configuration" do
      expect {
        |stub_block|
        subject.configure("jey", &stub_block)
      }.to yield_with_args(Axe::Configuration.instance)
    end
  end

  describe "#configure (jslib_path)" do
    it "should yield configuration with provided jslib_path" do
      different_axe_path = "different-axe-path/axe.js"

      AxeSelenium.configure do |c|
        c.jslib_path = different_axe_path
      end

      expect(Axe::Configuration.instance.jslib_path).to eq different_axe_path
    end
  end
end
