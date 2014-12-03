require 'rspec/a11y/custom_matcher'

module CustomA11yMatchers
  describe "BeAccessible" do

    before :each do
      @matcher = BeAccessible.new
      @page = double("page")
      allow(@page).to receive(:execute_script)
    end

    describe "#matches?" do

      context "default Capybara style" do

        before :each do
          allow(@page).to receive(:evaluate_script).and_return('{"violations":[]}')
        end

        it "should execute the testing script" do
          expect(@page).to receive(:execute_script).with(script_for_execute)
          @matcher.matches?(@page)
        end

        it "should evaluate the test results" do
          expect(@page).to receive(:evaluate_script).with(script_for_evaluate)
          @matcher.matches?(@page)
        end

        it "should return true if there are no violations" do
          expect( @matcher.matches?(@page) ).to eq(true)
        end

        it "should return false if there are violations" do
          allow(@page).to receive(:evaluate_script).and_return('{"violations":[{}]}')
          expect( @matcher.matches?(@page) ).to eq(false)
        end
      end

      context "alternate Watir style" do

        it "should evaluate the test results" do
          expect(@page).to receive(:execute_script).with(script_for_evaluate).and_return('{"violations":[]}')
          @matcher.matches?(@page)
        end
      end
    end

    describe "#failure_message" do

      before :each do
        @results = {
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
        allow(@page).to receive(:evaluate_script).and_return(@results.to_json)
      end

      it "should return formatted error message" do
        @matcher.matches?(@page)
        message = @matcher.failure_message

        expect(message).to include("Found 2 accessibility violations")

        @results['violations'].each do |v|

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

    private

    def script_for_execute(context=nil, options=nil)
      context = context ? "'#{context}'" : "document"
      options = options ? options.to_json : 'null'
      "dqre.a11yCheck(#{context}, #{options}, function(result){dqre.rspecResult = JSON.stringify(result);});"
    end

    def script_for_evaluate
      "(function(){return dqre.rspecResult;})()"
    end
  end
end
