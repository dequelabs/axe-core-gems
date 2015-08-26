require 'axe/api/context'

module Axe::API
  describe Context do

    describe "#include" do
      context "when given simple selector" do
        it "should push it on array" do
          subject.include "#selector"
          expect(subject.inclusion).to eq [ ["#selector"] ]
        end
      end

      context "when given multiple selectors" do
        it "should push them all onto the array" do
          subject.include ".foo", ".bar"
          expect(subject.inclusion).to eq [ [".foo"], [".bar"] ]
        end
      end

      context "when given single hash" do
        it "should flatten the hash" do
          subject.include(iframe: ".foo", selector: ".bar")
          expect(subject.inclusion).to eq [ [".foo", ".bar"] ]
        end
      end

      context "when given multiple hashes" do
        it "should flatten the hash" do
          subject.include(
            {iframe: ".foo", selector: ".bar"},
            {iframe: ".baz", selector: ".qux"}
          )
          expect(subject.inclusion).to eq [ [".foo", ".bar"], [".baz", ".qux"] ]
        end
      end

      context "when given string selectors *and* hashes" do
        it "should flatten the hash" do
          subject.include(".foo", ".bar", iframe: ".baz", selector: ".qux")
          expect(subject.inclusion).to eq [ [".foo"], [".bar"], [".baz", ".qux"] ]
        end
      end
    end

    describe "#exclude" do
      context "when given simple selector" do
        it "should push it on array" do
          subject.exclude "#selector"
          expect(subject.exclusion).to eq [ ["#selector"] ]
        end
      end

      context "when given multiple selectors" do
        it "should push them all onto the array" do
          subject.exclude ".foo", ".bar"
          expect(subject.exclusion).to eq [ [".foo"], [".bar"] ]
        end
      end

      context "when given single hash" do
        it "should flatten the hash" do
          subject.exclude(iframe: ".foo", selector: ".bar")
          expect(subject.exclusion).to eq [ [".foo", ".bar"] ]
        end
      end

      context "when given multiple hashes" do
        it "should flatten the hash" do
          subject.exclude(
            {iframe: ".foo", selector: ".bar"},
            {iframe: ".baz", selector: ".qux"}
          )
          expect(subject.exclusion).to eq [ [".foo", ".bar"], [".baz", ".qux"] ]
        end
      end

      context "when given string selectors *and* hashes" do
        it "should flatten the hash" do
          subject.exclude(".foo", ".bar", iframe: ".baz", selector: ".qux")
          expect(subject.exclusion).to eq [ [".foo"], [".bar"], [".baz", ".qux"] ]
        end
      end
    end

    describe "#to_json" do
      context "without an inclusion" do
        context "without an exclusion" do
          it "should emit only the exclude array" do
            pending "blocked until axe-core 1.1.0, which handles missing `include`"
            expect(subject.to_json).to eq '{"exclude":[]}'
          end
          #TODO: when 1.1.0 drops, kill this test and make ^above^ test active
          it "should emit `document`" do
            expect(subject.to_json).to eq "document"
          end
        end
        context "with exclusions" do
          before(:each) { subject.exclude ".ignore" }

          it "should only list exclusions" do
            pending "blocked until axe-core 1.1.0, which handles missing `include`"
            expect(subject.to_json).to eq '{"exclude":[[".ignore"]]}'
          end
          #TODO: when 1.1.0 drops, kill this test and make ^above^ test active
          it "should default include to `document`" do
            expect(subject.to_json).to eq '{"include":document,"exclude":[[".ignore"]]}'
          end
        end
      end

      context "with inclusions" do
        before(:each) { subject.include ".check" }

        context "without an exclusion" do
          it "should default to the document" do
            expect(subject.to_json).to eq '{"include":[[".check"]],"exclude":[]}'
          end
        end
        context "with exclusions" do
          before(:each) { subject.exclude ".ignore" }

          it "should default inclusion to document, list exclusions" do
            expect(subject.to_json).to eq '{"include":[[".check"]],"exclude":[[".ignore"]]}'
          end
        end
      end
    end

  end
end
