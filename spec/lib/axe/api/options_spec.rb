require 'spec_helper'
require 'axe/api/options'

module Axe::API
  describe Options do
    before :each do
      allow(subject.rules).to receive(:according_to)
      allow(subject.rules).to receive(:checking)
      allow(subject.rules).to receive(:checking_only)
      allow(subject.rules).to receive(:skipping)
    end

    describe "#according_to" do
      it "should be delegated to @rules" do
        subject.according_to([:foo])
        expect(subject.rules).to have_received(:according_to).with([:foo])
      end
    end

    describe "#checking_only" do
      it "should be delegated to @rules" do
        subject.checking_only([:foo])
        expect(subject.rules).to have_received(:checking_only).with([:foo])
      end
    end

    describe "#checking" do
      it "should be delegated to @rules" do
        subject.checking([:foo])
        expect(subject.rules).to have_received(:checking).with([:foo])
      end
    end

    describe "#skipping" do
      it "should be delegated to @rules" do
        subject.skipping([:foo])
        expect(subject.rules).to have_received(:skipping).with([:foo])
      end
    end

    describe "#with_options" do
      context "without existing custom options" do
        it "should merge additional custom options" do
          subject.with_options :foo => :bar
          expect(subject.custom).to eq :foo => :bar
        end
      end

      context "with existing custom rules" do
        before :each do
          subject.instance_variable_set :@custom, :foo => :bar
        end

        it "should merge additional custom options" do
          subject.with_options :baz => :qux
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
