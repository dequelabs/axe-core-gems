require "spec_helper"
require_relative "../lib/axe-rspec"

module AxeRSpec
  describe "RSpec" do
    it "extends with matcher be_axe_clean" do
      expect(be_axe_clean).to_not be_nil
    end
  end

  describe "test" do
    it "should correctly fail ci" do
      expect(1).to eq 2
    end
  end
end

# todo: add tests of usage with various webdrivers
