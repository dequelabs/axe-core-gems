require_relative "../../../lib/axe/api/selector"

module Axe::API
  describe Selector do
    context "from simple string" do
      let(:subject) { described_class.new "foo" }

      it "should be wrapped as an array" do
        expect(subject.to_a).to eq ["foo"]
      end
    end

    context "from iframe hash" do
      let(:subject) { described_class.new iframe: "foo", selector: "bar" }

      it "should flatten to wrapped array" do
        expect(subject.to_a).to eq ["foo", "bar"]
      end
    end

    context "from nested iframe hash" do
      let(:subject) {
        described_class.new(
          iframe: "foo",
          selector: {
            iframe: "bar",
            selector: {
              iframe: "baz",
              selector: "qux",
            },
          },
        )
      }

      it "should flatten to wrapped array" do
        expect(subject.to_a).to eq ["foo", "bar", "baz", "qux"]
      end
    end

    context "from array" do
      let(:subject) { described_class.new ["foo", "bar"] }

      it "should wrap array" do
        expect(subject.to_a).to eq ["foo", "bar"]
      end
    end

    context "from struct/class" do
      let(:subject) { described_class.new Struct.new(:iframe, :selector)["foo", "bar"] }

      it "should wrap array" do
        expect(subject.to_a).to eq ["foo", "bar"]
      end
    end
  end
end
