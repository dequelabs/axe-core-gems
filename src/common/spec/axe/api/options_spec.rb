require "spec_helper"
require_relative "../../../axe/api/options"

module Axe::API
  describe Options do
    let(:rules) { spy("rules") }
    let(:custom) { spy("custom") }
    before :each do
      subject.instance_variable_set :@rules, rules
      subject.instance_variable_set :@custom, custom
    end

    describe "#according_to" do
      it "should be delegated to @rules" do
        subject.according_to(:foo)
        expect(rules).to have_received(:according_to).with(:foo)
      end
    end

    describe "#checking_only" do
      it "should be delegated to @rules" do
        subject.checking_only(:foo)
        expect(rules).to have_received(:checking_only).with(:foo)
      end
    end

    describe "#checking" do
      it "should be delegated to @rules" do
        subject.checking(:foo)
        expect(rules).to have_received(:checking).with(:foo)
      end
    end

    describe "#skipping" do
      it "should be delegated to @rules" do
        subject.skipping(:foo)
        expect(rules).to have_received(:skipping).with(:foo)
      end
    end

    describe "#with_options" do
      context "without existing custom options" do
        it "should merge additional custom options" do
          subject.instance_variable_set :@custom, {}
          subject.with_options :foo => :bar
          expect(subject.instance_variable_get :@custom).to eq :foo => :bar
        end
      end

      context "with existing custom rules" do
        it "should merge additional custom options" do
          subject.instance_variable_set :@custom, :foo => :bar
          subject.with_options :baz => :qux
          expect(subject.instance_variable_get :@custom).to eq :foo => :bar, :baz => :qux
        end
      end
    end

    describe "#empty?" do
      context "without rules or cutom options" do
        it "should be empty" do
          subject.instance_variable_set :@rules, {}
          subject.instance_variable_set :@custom, {}
          expect(subject.empty?).to be(true)
        end
      end

      context "with rules" do
        it "should not be empty" do
          subject.instance_variable_set :@rules, { foo: "bar" }
          subject.instance_variable_set :@custom, {}
          expect(subject.empty?).to be(false)
        end
      end

      context "with cutom options" do
        it "should not be empty" do
          subject.instance_variable_set :@rules, {}
          subject.instance_variable_set :@custom, { foo: "bar" }
          expect(subject.empty?).to be(false)
        end
      end
    end

    describe "#to_json" do
      context "without duplicates" do
        before :each do
          subject.instance_variable_set :@custom, { :foo => :bar }
          allow(rules).to receive(:to_hash).and_return({ :baz => :qux })
        end

        it "should merge rules and custom options" do
          expect(subject.to_json).to eq '{"baz":"qux","foo":"bar"}'
        end
      end

      context "with duplicates" do
        before :each do
          subject.instance_variable_set :@custom, { :foo => :bar }
          allow(rules).to receive(:to_hash).and_return({ :foo => :qux })
        end

        it "should take custom options over rules" do
          expect(subject.to_json).to eq '{"foo":"bar"}'
        end
      end
    end
  end
end
