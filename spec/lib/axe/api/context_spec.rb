require 'axe/api/context'

module Axe::API
  describe Context, :focus => true do

    describe "#include" do

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

  end
end
