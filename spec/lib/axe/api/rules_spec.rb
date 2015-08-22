require 'spec_helper'
require 'axe/api/rules'

module Axe::API
  describe Rules do

    describe "#by_tags" do
      it "adds tags to list of tags for which to run rules" do
        subject.by_tags :foo, :bar
        expect(subject.tags).to include :foo, :bar
      end

      it "should return self for chaining" do
        expect(subject.by_tags).to be subject
      end
    end

    describe "#only" do
      it "adds rules to list of run-only rules" do
        subject.run_only :foo, :bar
        expect(subject.exclusive).to include :foo, :bar
      end

      it "should return self for chaining" do
        expect(subject.run_only).to be subject
      end
    end

    describe "#run" do
      it "adds rules to list of included rules" do
        subject.run :foo, :bar
        expect(subject.included).to include :foo, :bar
      end

      it "should return self for chaining" do
        expect(subject.run).to be subject
      end
    end

    describe "#skip" do
      it "adds rules to list of excluded rules" do
        subject.skip :foo, :bar
        expect(subject.excluded).to include :foo, :bar
      end

      it "should return self for chaining" do
        expect(subject.skip).to be subject
      end
    end

    describe "#to_hash" do
      context "with tags" do
        it "should list rules to run only for given tags" do
          subject.by_tags([:foo])
          expect(subject.to_hash).to include runOnly: { type: :tag, values: [:foo] }
        end
      end

      context "without tags" do
        it "should omit the runOnly:tag block" do
          expect(subject.to_hash).to_not include runOnly: a_hash_including(type: :tag)
        end
      end

      context "with exclusive rules" do
        it "should list rules to run exclusively" do
          subject.run_only([:foo])
          expect(subject.to_hash).to include runOnly: { type: :rule, values: [:foo] }
        end
      end

      context "without exclusive rules" do
        it "should omit the runOnly:rule block" do
          expect(subject.to_hash).to_not include runOnly: a_hash_including(type: :rule)
        end
      end

      context "with explicit rules to run and skip" do
        it "should have run rules enabled, skip rules disabled" do
          subject.run([:foo, :bar]).skip([:baz, :qux])
          expect(subject.to_hash).to include :rules => {
            foo: { enabled: true },
            bar: { enabled:true },
            baz: { enabled:false },
            qux: { enabled:false }
          }
        end
      end

      context "without explicit rules" do
        it "should omit rules" do
          expect(subject.to_hash).to_not include :rules
        end
      end
    end
  end
end
