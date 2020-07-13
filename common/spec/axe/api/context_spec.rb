require_relative "../../../axe/api/context"

module Axe::API
  describe Context do
    describe "#within" do
      context "when given simple selector" do
        it "should push it on array" do
          subject.within "#selector"
          expect(subject.instance_variable_get :@inclusion).to eq [["#selector"]]
        end
      end

      context "when given multiple selectors" do
        it "should push them all onto the array" do
          subject.within ".foo", ".bar"
          expect(subject.instance_variable_get :@inclusion).to eq [[".foo"], [".bar"]]
        end
      end

      context "when given single hash" do
        it "should flatten the hash" do
          subject.within(iframe: ".foo", selector: ".bar")
          expect(subject.instance_variable_get :@inclusion).to eq [[".foo", ".bar"]]
        end
      end

      context "when given multiple hashes" do
        it "should flatten the hash" do
          subject.within(
            { iframe: ".foo", selector: ".bar" },
            { iframe: ".baz", selector: ".qux" }
          )
          expect(subject.instance_variable_get :@inclusion).to eq [[".foo", ".bar"], [".baz", ".qux"]]
        end
      end

      context "when given string selectors *and* hashes" do
        it "should flatten the hash" do
          subject.within(".foo", ".bar", iframe: ".baz", selector: ".qux")
          expect(subject.instance_variable_get :@inclusion).to eq [[".foo"], [".bar"], [".baz", ".qux"]]
        end
      end
    end

    describe "#excluding" do
      context "when given simple selector" do
        it "should push it on array" do
          subject.excluding "#selector"
          expect(subject.instance_variable_get :@exclusion).to eq [["#selector"]]
        end
      end

      context "when given multiple selectors" do
        it "should push them all onto the array" do
          subject.excluding ".foo", ".bar"
          expect(subject.instance_variable_get :@exclusion).to eq [[".foo"], [".bar"]]
        end
      end

      context "when given single hash" do
        it "should flatten the hash" do
          subject.excluding(iframe: ".foo", selector: ".bar")
          expect(subject.instance_variable_get :@exclusion).to eq [[".foo", ".bar"]]
        end
      end

      context "when given multiple hashes" do
        it "should flatten the hash" do
          subject.excluding(
            { iframe: ".foo", selector: ".bar" },
            { iframe: ".baz", selector: ".qux" }
          )
          expect(subject.instance_variable_get :@exclusion).to eq [[".foo", ".bar"], [".baz", ".qux"]]
        end
      end

      context "when given string selectors *and* hashes" do
        it "should flatten the hash" do
          subject.excluding(".foo", ".bar", iframe: ".baz", selector: ".qux")
          expect(subject.instance_variable_get :@exclusion).to eq [[".foo"], [".bar"], [".baz", ".qux"]]
        end
      end
    end

    describe "#empty?" do
      context "without inclusion or exclusion rules" do
        it "should be empty" do
          subject.instance_variable_set :@inclusion, []
          subject.instance_variable_set :@exclusion, []
          expect(subject.empty?).to be(true)
        end
      end

      context "with inclusion rules" do
        it "should not be empty" do
          subject.instance_variable_set :@inclusion, ["foo"]
          subject.instance_variable_set :@exclusion, []
          expect(subject.empty?).to be(false)
        end
      end

      context "with exclusion rules" do
        it "should not be empty" do
          subject.instance_variable_set :@inclusion, []
          subject.instance_variable_set :@exclusion, ["foo"]
          expect(subject.empty?).to be(false)
        end
      end
    end

    describe "#to_json" do
      context "without an inclusion" do
        context "without an exclusion" do
          it "should emit an empty document" do
            expect(subject.to_json).to eq "{}"
          end
        end
        context "with exclusions" do
          before(:each) { subject.excluding ".ignore" }

          it "should only list exclusions" do
            expect(subject.to_json).to eq '{"exclude":[[".ignore"]]}'
          end
        end
      end

      context "with inclusions" do
        before(:each) { subject.within ".check" }

        context "without an exclusion" do
          it "should default to the document" do
            expect(subject.to_json).to eq '{"include":[[".check"]]}'
          end
        end
        context "with exclusions" do
          before(:each) { subject.excluding ".ignore" }

          it "should default inclusion to document, list exclusions" do
            expect(subject.to_json).to eq '{"include":[[".check"]],"exclude":[[".ignore"]]}'
          end
        end
      end
    end
  end
end
