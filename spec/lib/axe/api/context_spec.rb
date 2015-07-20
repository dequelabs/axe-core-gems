require 'axe/api/context'

module Axe::API
  describe Context do

    describe "#include" do
      it "should return self for chaining" do
        expect(subject.include("foo")).to be subject
      end

      context "when given simple selector" do
        it "should push it on array" do
          subject.include "#selector"
          expect(subject.inclusion).to eq [ ["#selector"] ]
        end
      end

      # TODO: validate what to do when :not(x,y,z) or :matches(), :lang(), :dir() (nested commas)
      context "when given multi-selector (comma-separated selector)" do
        it "should push each selector onto array" do
          subject.include ".foo, .bar, .baz"
          expect(subject.inclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end

        it "should allow any whitespace" do
          subject.include ".foo,     .bar, .baz"
          expect(subject.inclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end
      end

      context "when given array" do
        it "should concatenate the array" do
          subject.include [ ".foo", ".bar", ".baz" ]
          expect(subject.inclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end
      end

      context "when given nested array" do
        it "should concatenate the array" do
          subject.include [ [ ".foo" ], [".bar", ".baz" ] ]
          expect(subject.inclusion).to eq [ [ ".foo" ], [".bar", ".baz" ] ]
        end
      end
    end

    describe "#exclude" do
      it "should return self for chaining" do
        expect(subject.exclude("foo")).to be subject
      end

      context "when given simple selector" do
        it "should push it on array" do
          subject.exclude "#selector"
          expect(subject.exclusion).to eq [ ["#selector"] ]
        end
      end

      # TODO: validate what to do when :not(x,y,z) or :matches(), :lang(), :dir() (nested commas)
      context "when given multi-selector (comma-separated selector)" do
        it "should push each selector onto array" do
          subject.exclude ".foo, .bar, .baz"
          expect(subject.exclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end

        it "should allow any whitespace" do
          subject.exclude ".foo,     .bar, .baz"
          expect(subject.exclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end
      end

      context "when given array" do
        it "should concatenate the array" do
          subject.exclude [ ".foo", ".bar", ".baz" ]
          expect(subject.exclusion).to eq [ [".foo"], [".bar"], [".baz"] ]
        end
      end

      context "when given nested array" do
        it "should concatenate the array" do
          subject.exclude [ [ ".foo" ], [".bar", ".baz" ] ]
          expect(subject.exclusion).to eq [ [ ".foo" ], [".bar", ".baz" ] ]
        end
      end
    end

    describe "#to_json" do
      context "without an inclusion" do
        context "without an exclusion" do
          xit "should emit only the exclude array" do
            expect(subject.to_json).to eq '{"exclude":[]}'
          end
          #TODO: when 1.1.0 drops, kill this test and make ^above^ test active
          it "should emit `document`" do
            expect(subject.to_json).to eq "document"
          end
        end
        context "with exclusions" do
          before(:each) { subject.exclude ".ignore" }

          xit "should only list exclusions" do
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
