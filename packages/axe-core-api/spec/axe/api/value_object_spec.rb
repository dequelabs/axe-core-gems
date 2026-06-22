require "spec_helper"
require_relative "../../../lib/axe/api/value_object"

module Axe::API
  describe ValueObject do
    describe "Virtus-compatible lenient coercion" do
      describe "Integer attribute" do
        let(:klass) do
          Class.new(ValueObject) do
            values { attribute :count, Integer }
          end
        end

        it "coerces numeric strings to Integer" do
          expect(klass.new(count: "42").count).to eq(42)
          expect(klass.new(count: "-7").count).to eq(-7)
        end

        it "passes through non-numeric strings unchanged (does not raise)" do
          expect(klass.new(count: "abc").count).to eq("abc")
          expect(klass.new(count: "42abc").count).to eq("42abc")
        end

        it "coerces numeric types via to_i" do
          expect(klass.new(count: 3.7).count).to eq(3)
          expect(klass.new(count: 5).count).to eq(5)
        end

        it "preserves nil" do
          expect(klass.new(count: nil).count).to be_nil
        end
      end

      describe "Float attribute" do
        let(:klass) do
          Class.new(ValueObject) do
            values { attribute :ratio, Float }
          end
        end

        it "coerces numeric strings to Float" do
          expect(klass.new(ratio: "3.14").ratio).to eq(3.14)
          expect(klass.new(ratio: ".5").ratio).to eq(0.5)
          expect(klass.new(ratio: "-2.5").ratio).to eq(-2.5)
          expect(klass.new(ratio: "42").ratio).to eq(42.0)
        end

        it "passes through non-numeric strings unchanged (does not raise)" do
          expect(klass.new(ratio: "abc").ratio).to eq("abc")
        end

        it "coerces numeric types via to_f" do
          expect(klass.new(ratio: 42).ratio).to eq(42.0)
        end

        it "preserves nil" do
          expect(klass.new(ratio: nil).ratio).to be_nil
        end
      end

      describe "Boolean attribute" do
        let(:klass) do
          Class.new(ValueObject) do
            values { attribute :flag, TrueClass }
          end
        end

        it "maps Virtus-style truthy strings to true" do
          %w[1 t T true TRUE].each do |s|
            expect(klass.new(flag: s).flag).to be(true), "expected #{s.inspect} -> true"
          end
        end

        it "maps Virtus-style falsy strings to false" do
          %w[0 f F false FALSE].each do |s|
            expect(klass.new(flag: s).flag).to be(false), "expected #{s.inspect} -> false"
          end
        end

        it "passes through booleans unchanged" do
          expect(klass.new(flag: true).flag).to be(true)
          expect(klass.new(flag: false).flag).to be(false)
        end

        it "passes through unrecognized strings unchanged" do
          expect(klass.new(flag: "maybe").flag).to eq("maybe")
        end

        it "preserves nil" do
          expect(klass.new(flag: nil).flag).to be_nil
        end
      end
    end

    describe "#to_hash" do
      it "dispatches dynamically to subclass #to_h overrides" do
        klass = Class.new(ValueObject) do
          values { attribute :x }
          def to_h
            { x: x, extra: :from_override }
          end
        end

        instance = klass.new(x: 1)
        expect(instance.to_hash).to eq(instance.to_h)
        expect(instance.to_hash).to eq(x: 1, extra: :from_override)
      end
    end

    describe "#inspect" do
      it "renders attributes inline" do
        klass = Class.new(ValueObject) do
          def self.name; "Sample"; end
          values do
            attribute :a
            attribute :b
          end
        end

        expect(klass.new(a: 1, b: "x").inspect).to eq('#<Sample a=1 b="x">')
      end

      it "has no trailing space when there are no attributes" do
        klass = Class.new(ValueObject) do
          def self.name; "Empty"; end
        end

        expect(klass.new.inspect).to eq("#<Empty>")
      end
    end
  end
end
