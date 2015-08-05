require 'spec_helper'
require 'axe/api/audit'

module Axe::API
  describe Audit do
    let(:subject) { described_class.new invocation, results }
    let(:invocation) { "inny vacation" }
    let(:results) { spy('results') }

    before :each do
      allow(results).to receive(:failure_message).and_return("results failure message")
    end

    its(:failure_message) do
      is_expected.to eq "results failure message\nInvocation: inny vacation"
    end

    its(:failure_message_when_negated) do
      is_expected.to eq "Expected to find accessibility violations. None were detected.\nInvocation: inny vacation"
    end

    context "when there are no violations" do
      before :each do
        allow(results).to receive(:violations).and_return []
      end

      it { is_expected.to be_passed }
    end

    context "when there are violations" do
      before :each do
        allow(results).to receive(:violations).and_return ["violation1"]
      end

      it { is_expected.to_not be_passed }
    end
  end
end
