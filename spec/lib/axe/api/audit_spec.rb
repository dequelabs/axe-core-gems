require 'spec_helper'
require 'axe/api/audit'

module Axe::API
  describe Audit do
    let(:subject) { described_class.new invocation, results }
    let(:invocation) { spy('invocation') }
    let(:results) { spy('results') }

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

  xdescribe Audit do
    let(:a11y_check) { spy('a11y_check') }
    before :each do
      subject.instance_variable_set :@a11y_check, a11y_check
    end

    describe "#run_against" do
      let(:page) { spy('page') }
      let(:results) { spy('results') }

      before :each do
        allow(a11y_check).to receive(:to_js).and_return("a11yCheck()")
        allow(page).to receive(:evaluate_script).and_return('violations' => [])
      end

      it "should inject the axe-core lib" do
        subject.run_against(page)
        expect(page).to have_received(:execute_script).with(a_string_starting_with ("/*! aXe"))
      end

      it "should execute the the A11yCheck script" do
        subject.run_against(page)
        expect(page).to have_received(:execute_script).with("a11yCheck()")
      end

      it "should parse and return the results" do
        expect(Results).to receive(:new).with('violations' => []).and_return results
        expect(subject.run_against(page)).to be results
      end

      it "should save the original invocation on the results" do
        expect_any_instance_of(Results).to receive(:invocation=).with("a11yCheck()")
        subject.run_against(page)
      end

      it "should retry until the a11yCheck results are ready", :slow do
        nil_invocations = Array.new(5, nil)
        allow(page).to receive(:evaluate_script).and_return(*nil_invocations, 'violations' => [])
        expect(Results).to receive(:new).with('violations' => []).and_return results

        expect(subject.run_against(page)).to be results
      end

      it "should timeout if results aren't ready after some time", :slow do
        allow(page).to receive(:evaluate_script) { sleep(5) and {'violations' => []} }
        expect { subject.run_against(page) }.to raise_error Timeout::Error
      end
    end
  end
end
