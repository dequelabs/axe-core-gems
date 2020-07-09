require "spec_helper"
require_relative "../lib/axe-rspec"

module AxeRSpec
  describe "RSpec" do
    it "extends with matcher be_accessible" do
      expect(be_accessible).to_not be_nil
    end
  end
end

# todo: add tests of usage with various webdrivers
