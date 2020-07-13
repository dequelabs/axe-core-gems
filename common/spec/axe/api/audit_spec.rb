require "spec_helper"
require_relative "../../../axe/api/audit"

module Axe::API
  describe Audit do
    subject { described_class.new invocation, results }
    let(:invocation) { "inny vacation" }
    let(:results) { spy("results", failure_message: "results failure message") }

    its(:failure_message) do
      is_expected.to eq "results failure message\nInvocation: inny vacation"
    end

    its(:failure_message_when_negated) do
      is_expected.to eq "Expected to find accessibility violations. None were detected.\n\nInvocation: inny vacation"
    end

    context "when there are no violations" do
      let(:results) { spy("results", violations: []) }

      it { is_expected.to be_passed }
    end

    context "when there are violations" do
      let(:results) { spy("results", violations: ["violation1"]) }

      it { is_expected.to_not be_passed }
    end
  end
end
