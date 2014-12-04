require 'rspec/a11y/custom_matcher'

module CustomA11yMatchers
  describe "BeAccessible" do

    before :each do
      @matcher = BeAccessible.new
      @page = double("page")
      allow(@page).to receive(:execute_script)
    end

    context "default (Capybara style)" do

      before :each do
        allow(@page).to receive(:evaluate_script).and_return('{"violations":[]}')
      end

      describe "#matches?" do

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

      describe "#within" do

        it "should set the context of the test script" do
          expect(@page).to receive(:execute_script).with(script_for_execute("'#selector'"))
          @matcher.within("#selector").matches?(@page)
        end
      end

      describe "#excluding" do

        it "should set the include/exclude context of the test script" do
          expect(@page).to receive(:execute_script).with(script_for_execute('{include:[["#this"]],exclude:[["#other"]]}'))
          @matcher.within("#this").excluding("#other").matches?(@page)
        end

        it "should default to document as include" do
          expect(@page).to receive(:execute_script).with(script_for_execute('{include:document,exclude:[["#other"]]}'))
          @matcher.excluding("#other").matches?(@page)
        end

        it "should accept comma-separated values" do
          expect(@page).to receive(:execute_script).with(script_for_execute('{include:document,exclude:[[".exclude1"],[".exclude2"],[".exclude3"]]}'))
          @matcher.excluding(".exclude1,.exclude2, .exclude3").matches?(@page)
        end

        it "should accept an array of values" do
          expect(@page).to receive(:execute_script).with(script_for_execute('{include:document,exclude:[[".exclude1"],[".exclude2"],[".exclude3"]]}'))
          @matcher.excluding([".exclude1",".exclude2",".exclude3"]).matches?(@page)
        end
      end

      describe "#for_tag" do

        it "should pass the tag options to the script" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a"]}}'))
          @matcher.for_tag("wcag2a").matches?(@page)
        end

        it "should accept comma-separated rules" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
          @matcher.for_tag("wcag2a,wcag2aa, section508").matches?(@page)
        end

        it "should accept an array of rules" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
          @matcher.for_tag(["wcag2a","wcag2aa", "section508"]).matches?(@page)
        end

        it "should be usable as plural" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
          @matcher.for_tags("wcag2a,wcag2aa, section508").matches?(@page)
        end
      end

      describe "#for_rule" do

        it "should pass the rule options to the script" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label"]}}'))
          @matcher.for_rule("label").matches?(@page)
        end

        it "should accept comma-separated rules" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
          @matcher.for_rule("label,blink, list").matches?(@page)
        end

        it "should accept an array of rules" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
          @matcher.for_rule(["label","blink", "list"]).matches?(@page)
        end

        it "should be usable as plural" do
          expect(@page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
          @matcher.for_rules("label,blink, list").matches?(@page)
        end
      end

      describe "#with_options" do

        it "should pass the options string to the script" do
          test_options = '{these:{are:{my:"options"}}}'
          expect(@page).to receive(:execute_script).with(script_for_execute('document', test_options))
          @matcher.with_options(test_options).matches?(@page)
        end
      end
    end

    context "alternate (Watir style)" do

      describe "#matches?" do

        it "should evaluate the test results" do
          expect(@page).to receive(:execute_script).with(script_for_evaluate).and_return('{"violations":[]}')
          @matcher.matches?(@page)
        end
      end
    end

    private

    def script_for_execute(context='document', options='null')
      "dqre.a11yCheck(#{context}, #{options}, function(result){dqre.rspecResult = JSON.stringify(result);});"
    end

    def script_for_evaluate
      "(function(){return dqre.rspecResult;})()"
    end
  end
end
