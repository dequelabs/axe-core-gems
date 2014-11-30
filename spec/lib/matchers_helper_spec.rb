require 'spec_helper'

module RSpec
  module Matchers
    module Custom
      module A11yHelper

        describe "#run_test_for" do

          it "should execute the test script on the page" do
            scope = "body"
            script = "dqre.a11yCheck('#{scope}', null, function(result){window.dqreResult = JSON.stringify(result);});"

            page = double("page")
            expect(page).to receive(:execute_script) { script }

            RSpec::Matchers::Custom::A11yHelper.run_test_for(page, scope)
          end
        end
      end
    end
  end
end
