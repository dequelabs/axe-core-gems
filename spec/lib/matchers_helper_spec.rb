require 'spec_helper'

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
      end
    end
  end
end
