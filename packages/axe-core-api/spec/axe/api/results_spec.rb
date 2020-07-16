require "spec_helper"
require_relative "../../../lib/axe/api/results"

module Axe::API
  describe Results do
    describe "#failure_message" do
      context "when the results objects are complete" do
        subject {
          Results.new "violations" => [{
                        "help" => "V1 help",
                        "helpUrl" => "V1 url",
                        "nodes" => [{
                          "target" => ["#target-1-1"],
                          "html" => "V1 html",
                          "any" => [{ "message" => "Fix from any 1" }],
                          "all" => [{ "message" => "Fix from all 1" }],
                        }],
                      }, {
                        "help" => "V2 help",
                        "helpUrl" => "V2 url",
                        "nodes" => [{
                          "target" => ["#target-2-1", "#target-2-2"],
                          "html" => "V2 html",
                          "any" => [{ "message" => "Fix from any 2" }],
                          "all" => [{ "message" => "Fix from all 2" }],
                        }],
                      }, {
                        "help" => "V3 help",
                        "helpUrl" => "V3 url",
                        "nodes" => [{
                          "target" => [["#target-3-1", "#target-3-2"]],
                          "html" => "V3 html",
                          "any" => [{ "message" => "Fix from any 3" }],
                          "all" => [{ "message" => "Fix from all 3" }],
                        }],
                      }]
        }

        it "should return formatted error message" do
          subject.failure_message.tap do |message|
            expect(message).to include("Found 3 accessibility violations")

            expect(message).to include "V1 help", "V2 help", "V3 help"
            expect(message).to include "V1 url", "V2 url", "V3 url"

            expect(message).to include "V1 html", "V2 html", "V3 html"
            expect(message).to include "#target-1-1", "#target-2-1, #target-2-2",
                                       "#target-3-1, #target-3-2"

            expect(message).to include "Fix from any 1", "Fix from all 1", "Fix from any 2", "Fix from all 2", "Fix from any 3", "Fix from all 3"
          end
        end
      end

      context "when the results objects are incomplete" do
        subject {
          Results.new "violations" => [{
                        "help" => nil,
                        "helpUrl" => nil,
                        "nodes" => nil,
                      }, {
                        "help" => "V2 help",
                        "helpUrl" => "V2 url",
                        "nodes" => [{
                          "target" => nil,
                          "html" => nil,
                          "any" => nil,
                          "all" => nil,
                        }, {
                          "target" => [nil],
                          "html" => nil,
                          "any" => [nil],
                          "all" => [nil],

                        }, nil],
                      }]
        }

        it "should gracefully handle formatting" do
          expect(subject.failure_message).to_not be_nil
        end
      end
    end
  end
end
