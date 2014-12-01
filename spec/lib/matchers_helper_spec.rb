require 'spec_helper'
require 'json'

module RSpec
  module Matchers
    module Custom
      module A11yHelper

        describe "#run_test_for" do

          before :each do
            script = "dqre.a11yCheck('#{scope}', #{options.to_json}, function(result){dqre.rspecResult = JSON.stringify(result);});"
            @page = double("page")
            expect(@page).to receive(:execute_script).with(script)
          end

          context "default scope" do
            let(:scope) { "body" }
            let(:options) { nil }

            it "should execute the test script for body" do
              RSpec::Matchers::Custom::A11yHelper.run_test_for(@page)
            end
          end

          context "custom scope" do
            let(:scope) { "#custom" }
            let(:options) { nil }

            it "should execute the test script for defined scope" do
              RSpec::Matchers::Custom::A11yHelper.run_test_for(@page, scope)
            end
          end

          context "custom options" do
            let(:scope) { "body" }
            let(:options) { {runOnly: {type: "tag", values: ["wcag2a"]}} }

            it "should execute the test script with options" do
              RSpec::Matchers::Custom::A11yHelper.run_test_for(@page, scope, options)
            end
          end
        end

        describe "#get_test_results" do

          before :each do
            @page = double("page")
            @script = "(function(){return dqre.rspecResult;})()"
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

        describe "#message_for_results" do
          it "should return formatted error message for violations" do
            results = {
              "violations" => [
                {
                  "help" => "Help for Violation 1",
                  "nodes" => [
                    {
                      "target" => ["#target-1-1"],
                      "html" => "<input id=\"target-1-1\" type=\"text\">",
                      "failureSummary" => "Fix these for target-1-1"
                    },
                    {
                      "target" => ["#target-1-2","#target-1-2-2"],
                      "html" => "<input id=\"target-1-2\" type=\"text\">",
                      "failureSummary" => "Fix these for target-1-2"
                    }
                  ],
                  "helpUrl" => "https://dequeuniversity.com/violation-1"
                },
                {
                  "help" => "Help for Violation 2",
                  "nodes" => [
                    {
                      "target" => ["#target-2-1"],
                      "html" => "<input id=\"target-2-1\" type=\"text\">",
                      "failureSummary" => "Fix these for target-2-1"
                    },
                    {
                      "target" => ["#target-2-2","#target-2-2-2"],
                      "html" => "<input id=\"target-2-2\" type=\"text\">",
                      "failureSummary" => "Fix these for target-2-2"
                    }
                  ],
                  "helpUrl" => "https://dequeuniversity.com/violation-2"
                }
              ]
            }

            message = RSpec::Matchers::Custom::A11yHelper.message_for_results(results)

            expect(message).to include("Found 2 accessibility violations")
            results['violations'].each do |v|
              expect(message).to include(v['help'])
              expect(message).to include(v['helpUrl'])
              v['nodes'].each do |n|
                expect(message).to include(n['html'])
                expect(message).to include(n['failureSummary'])
                n['target'].each do |t|
                  expect(message).to include(t)
                end
              end
            end
          end
        end
      end
    end
  end
end
