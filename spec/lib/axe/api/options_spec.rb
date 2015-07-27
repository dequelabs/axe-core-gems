require 'spec_helper'
require 'axe/api/options'

module Axe::API
  describe Options do
    before :each do
      allow(subject.rules).to receive(:by_tags)
      allow(subject.rules).to receive(:run_only)
      allow(subject.rules).to receive(:run)
      allow(subject.rules).to receive(:skip)
    end

    describe "#rules_by_tags" do
      it "should be delegated to @rules.by_tag" do
        subject.rules_by_tags([:foo])
        expect(subject.rules).to have_received(:by_tags).with([:foo])
      end
    end

    describe "#run_only_rules" do
      it "should be delegated to @rules.run_only" do
        subject.run_only_rules([:foo])
        expect(subject.rules).to have_received(:run_only).with([:foo])
      end
    end

    describe "#run_rules" do
      it "should be delegated to @rules.run" do
        subject.run_rules([:foo])
        expect(subject.rules).to have_received(:run).with([:foo])
      end
    end

    describe "#skip_rules" do
      it "should be delegated to @rules.skip" do
        subject.skip_rules([:foo])
        expect(subject.rules).to have_received(:skip).with([:foo])
      end
    end

    describe "#add" do
      context "without existing custom options" do
        it "should merge additional custom options" do
          subject.add :foo => :bar
          expect(subject.custom).to eq :foo => :bar
        end
      end

      context "with existing custom rules" do
        before :each do
          subject.instance_variable_set :@custom, :foo => :bar
        end

        it "should merge additional custom options" do
          subject.add :baz => :qux
          expect(subject.custom).to eq :foo => :bar, :baz => :qux
        end
      end
    end

    describe "#to_json" do
      before :each do
        subject.instance_variable_set :@custom, custom
        allow(subject.rules).to receive(:to_hash).and_return(rules)
      end

      context "without duplicates" do
        let(:custom) { {:foo => :bar } }
        let(:rules) { { :baz => :qux } }

        it "should merge rules and custom options" do
          expect(subject.to_json).to eq '{"baz":"qux","foo":"bar"}'
        end
      end

      context "with duplicates" do
        let(:custom) { {:foo => :bar } }
        let(:rules) { { :foo => :qux } }

        it "should take custom options over rules" do
          expect(subject.to_json).to eq '{"foo":"bar"}'
        end
      end
    end
  end
end
