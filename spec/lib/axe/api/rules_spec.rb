require 'spec_helper'
require 'axe/api/rules'

module Axe::API
  describe Rules, :focus do

    describe "#run" do
      it "adds rules to list of included rules" do
        subject.run "foo"
        expect(subject.included).to include "foo"
      end

      it "should accept single rule" do
        subject.run "foo"
        expect(subject.included).to include "foo"
      end

      it "should accept variadic rules" do
        subject.run "foo", "bar"
        expect(subject.included).to include "foo", "bar"
      end

      it "should accept array of rules" do
        subject.run ["foo", "bar"]
        expect(subject.included).to include "foo", "bar"
      end

      it "should return self for chaining" do
        expect(subject.run).to be subject
      end
    end

    describe "#skip" do
      it "adds rules to list of excluded rules" do
        subject.skip "foo"
        expect(subject.excluded).to include "foo"
      end

      it "should accept single rule" do
        subject.skip "foo"
        expect(subject.excluded).to include "foo"
      end

      it "should accept variadic rules" do
        subject.skip "foo", "bar"
        expect(subject.excluded).to include "foo", "bar"
      end

      it "should accept array of rules" do
        subject.skip ["foo", "bar"]
        expect(subject.excluded).to include "foo", "bar"
      end

      it "should return self for chaining" do
        expect(subject.skip).to be subject
      end
    end

    describe "#to_json" do

      context "with explicit rules to run and skip" do
        it "should have run rules enabled, skip rules disabled" do
          subject.run("foo", "bar").skip("baz", "qux")
          expect(subject.to_json).to eq '{"rules":{"foo":{"enabled":true},"bar":{"enabled":true},"baz":{"enabled":false},"qux":{"enabled":false}}}'
        end
      end
    end
  end
end
