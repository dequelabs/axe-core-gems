require 'spec_helper'
require 'json'

module RSpec
  module Matchers
    module Custom
      module A11yHelper

        describe "#run_test_for" do

          before :each do
            script = "dqre.a11yCheck('#{scope}', null, function(result){window.dqreResult = JSON.stringify(result);});"
            @page = double("page")
            expect(@page).to receive(:execute_script) { script }
          end

          context "default scope" do
            let(:scope) { "body" }

            it "should execute the test script for body" do
              RSpec::Matchers::Custom::A11yHelper.run_test_for(@page)
            end
          end

          context "custom scope" do
            let(:scope) { "#custom" }

            it "should execute the test script for defined scope" do
              RSpec::Matchers::Custom::A11yHelper.run_test_for(@page, scope)
            end
          end
        end

        describe "#get_test_results" do

          before :each do
            @page = double("page")
            @script = "dqreReturn();"
          end

          context "capybara style" do

            it "should evaluate the return script" do
              expect(@page).to receive(:evaluate_script) { @script }
              RSpec::Matchers::Custom::A11yHelper.get_test_results(@page)
            end

            it "should return the results" do
              expected_results = '{"violations":[]}'
              allow(@page).to receive(:evaluate_script).and_return(expected_results)
              actual_results = RSpec::Matchers::Custom::A11yHelper.get_test_results(@page)
              expect(actual_results).to eq(expected_results)
            end
          end

          context "watir style" do

            it "should execute the return script" do
              expect(@page).to receive(:execute_script) { @script }
              RSpec::Matchers::Custom::A11yHelper.get_test_results(@page)
            end

            it "should return the results" do
              expected_results = '{"violations":[]}'
              allow(@page).to receive(:execute_script).and_return(expected_results)
              actual_results = RSpec::Matchers::Custom::A11yHelper.get_test_results(@page)
              expect(actual_results).to eq(expected_results)
            end
          end
        end
      end
    end
  end
end
