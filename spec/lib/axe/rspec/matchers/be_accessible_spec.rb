require 'timeout'
require 'axe/rspec/matchers/be_accessible'

module Axe::RSpec::Matchers
  describe BeAccessible do
    let(:page) { spy('page') }

    before :each do
      allow(page).to receive(:evaluate_script)
      expect(page).to receive(:execute_script).with(a_string_starting_with ("/*! aXe"))
    end

    before :each do
      allow(page).to receive(:evaluate_script).and_return('violations' => [])
    end

    describe "#matches?" do

      it "should execute the testing script" do
        expect(page).to receive(:execute_script).with(script_for_execute)
        subject.matches?(page)
      end

      it "should evaluate the test results" do
        expect(page).to receive(:evaluate_script).with(script_for_evaluate)
        subject.matches?(page)
      end

      it "should return true if there are no violations" do
        expect( subject.matches?(page) ).to be true
      end

      it "should return false if there are violations" do
        allow(page).to receive(:evaluate_script).and_return('violations' => [{}])
        expect( subject.matches?(page) ).to be false
      end

      it "should retry until the a11yCheck results are ready", :slow do
        nil_invocations = Array.new(5, nil)
        allow(page).to receive(:evaluate_script).and_return(*nil_invocations, 'violations' => [])
        expect( subject.matches?(page) ).to be true
      end

      it "should timeout if results aren't ready after some time", :slow do
        allow(page).to receive(:evaluate_script) { sleep(5) and {'violations' => []} }
        expect { subject.matches?(page) }.to raise_error Timeout::Error
      end
    end

    describe "#failure_message" do
      before :each do
        allow(page).to receive(:evaluate_script).and_return(results)
      end

      let(:results) { {
        "violations" => [ {
          "help" => "V1 help",
          "helpUrl" => "V1 url",
          "nodes" => [ {
            "target" => ["#target-1-1"],
            "html" => "V1 html",
            "any" => [ { "message" => "Fix from any 1" } ],
            "all" => [ { "message" => "Fix from all 1" } ]
          } ]
        }, {
          "help" => "V2 help",
          "helpUrl" => "V2 url",
          "nodes" => [ {
            "target" => ["#target-2-1", "#target-2-2"],
            "html" => "V2 html",
            "any" => [ { "message" => "Fix from any 2" } ],
            "all" => [ { "message" => "Fix from all 2" } ]
          } ]
        } ]
      } }

      it "should return formatted error message" do
        subject.matches?(page)
        subject.failure_message.tap do |message|
          expect(message).to include("Found 2 accessibility violations")

          expect(message).to include "V1 help", "V2 help"
          expect(message).to include "V1 url", "V2 url"

          expect(message).to include "V1 html", "V2 html"
          expect(message).to include "#target-1-1", "#target-2-1, #target-2-2"

          expect(message).to include "Fix from any 1", "Fix from all 1", "Fix from any 2", "Fix from all 2"
        end
      end
    end

    describe "#within" do

      it "should set the context of the test script" do
        expect(page).to receive(:execute_script).with(script_for_execute("'#selector'"))
        subject.within("#selector").matches?(page)
      end

      it "should accept comma-separated values" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":[[".include1"],[".include2"],[".include3"]],"exclude":[]}'))
        subject.within(".include1,.include2, .include3").matches?(page)
      end

      it "should accept an array of values" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":[[".include1"],[".include2"],[".include3"]],"exclude":[]}'))
        subject.within([".include1",".include2",".include3"]).matches?(page)
      end

      it "should accept nested arrays without rewrapping" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":[[".include1"],[".include2"],["#frame1",".include3"]],"exclude":[]}'))
        subject.within([[".include1"],[".include2"],["#frame1",".include3"]]).matches?(page)
      end
    end

    describe "#excluding" do

      it "should set the include/exclude context of the test script" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":[["#this"]],"exclude":[["#other"]]}'))
        subject.within("#this").excluding("#other").matches?(page)
      end

      it "should default to document as include" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":document,"exclude":[["#other"]]}'))
        subject.excluding("#other").matches?(page)
      end

      it "should accept comma-separated values" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":document,"exclude":[[".exclude1"],[".exclude2"],[".exclude3"]]}'))
        subject.excluding(".exclude1,.exclude2, .exclude3").matches?(page)
      end

      it "should accept an array of values" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":document,"exclude":[[".exclude1"],[".exclude2"],[".exclude3"]]}'))
        subject.excluding([".exclude1",".exclude2",".exclude3"]).matches?(page)
      end

      it "should accept nested arrays without rewrapping" do
        expect(page).to receive(:execute_script).with(script_for_execute('{"include":document,"exclude":[[".exclude1"],[".exclude2"],["#frame1",".exclude3"]]}'))
        subject.excluding([[".exclude1"],[".exclude2"],["#frame1",".exclude3"]]).matches?(page)
      end
    end

    describe "#for_tag" do

      it "should pass the tag options to the script" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a"]}}'))
        subject.for_tag("wcag2a").matches?(page)
      end

      it "should accept comma-separated rules" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
        subject.for_tag("wcag2a,wcag2aa, section508").matches?(page)
      end

      it "should accept an array of rules" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
        subject.for_tag(["wcag2a","wcag2aa", "section508"]).matches?(page)
      end

      it "should be usable as plural" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"tag",values:["wcag2a","wcag2aa","section508"]}}'))
        subject.for_tags("wcag2a,wcag2aa, section508").matches?(page)
      end
    end

    describe "#for_rule" do

      it "should pass the rule options to the script" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label"]}}'))
        subject.for_rule("label").matches?(page)
      end

      it "should accept comma-separated rules" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
        subject.for_rule("label,blink, list").matches?(page)
      end

      it "should accept an array of rules" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
        subject.for_rule(["label","blink", "list"]).matches?(page)
      end

      it "should be usable as plural" do
        expect(page).to receive(:execute_script).with(script_for_execute('document', '{runOnly:{type:"rule",values:["label","blink","list"]}}'))
        subject.for_rules("label,blink, list").matches?(page)
      end
    end

    describe "#with_options" do

      it "should pass the options string to the script" do
        test_options = '{these:{are:{my:"options"}}}'
        expect(page).to receive(:execute_script).with(script_for_execute('document', test_options))
        subject.with_options(test_options).matches?(page)
      end
    end

    private

    def script_for_execute(context='document', options='null')
      "axe.a11yCheck(#{context}, #{options}, function(results){axe.rspecResult = results;});"
    end

    def script_for_evaluate
      "axe.rspecResult"
    end
  end
end
