require 'spec_helper'
require 'axe/api/rules'

module Axe::API
  describe Rules do

    describe "#according_to" do
      it "adds tags to list of tags for which to run rules" do
        subject.according_to :foo, :bar
        expect(subject.instance_variable_get :@tags).to include :foo, :bar
      end
    end

    describe "#checking" do
      it "adds rules to list of included rules" do
        subject.checking :foo, :bar
        expect(subject.instance_variable_get :@included).to include :foo, :bar
      end
    end

    describe "#checking_only" do
      it "adds rules to list of run-only rules" do
        subject.checking_only :foo, :bar
        expect(subject.instance_variable_get :@exclusive).to include :foo, :bar
      end
    end

    describe "#skipping" do
      it "adds rules to list of excluded rules" do
        subject.skipping :foo, :bar
        expect(subject.instance_variable_get :@excluded).to include :foo, :bar
      end
    end

    describe "#to_hash" do
      context "with tags" do
        it "should list rules to run only for given tags" do
          subject.according_to(:foo)
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
          subject.checking_only(:foo)
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
          subject.checking(:foo, :bar)
          subject.skipping(:baz, :qux)
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
