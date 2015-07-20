require 'spec_helper'
require 'axe/api/rules'

module Axe::API
  describe Rules, :focus do

    describe "#by_tag" do
      it "adds tags to list of tags for which to run rules" do
        subject.by_tag "foo"
        expect(subject.tags).to include "foo"
      end

      it "should accept single tag" do
        subject.by_tag "foo"
        expect(subject.tags).to include "foo"
      end

      it "should accept variadic tag" do
        subject.by_tag "foo", "bar"
        expect(subject.tags).to include "foo", "bar"
      end

      it "should accept array of tags" do
        subject.by_tag ["foo", "bar"]
        expect(subject.tags).to include "foo", "bar"
      end

      it "should return self for chaining" do
        expect(subject.by_tag).to be subject
      end
    end

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
      context "with tags" do
        it "should list rules to run only for given tags" do
          subject.by_tag("foo")
          expect(subject.to_json).to eq '{"runOnly":{"type":"tag","values":["foo"]},"rules":{}}'
        end
      end

      context "with explicit rules to run and skip" do
        it "should have run rules enabled, skip rules disabled" do
          subject.run("foo", "bar").skip("baz", "qux")
          expect(subject.to_json).to eq '{"runOnly":{"type":"tag","values":[]},"rules":{"foo":{"enabled":true},"bar":{"enabled":true},"baz":{"enabled":false},"qux":{"enabled":false}}}'
        end
      end
    end
  end
end
