require 'webdriver_script_adapter/exec_eval_script_adapter'

module WebDriverScriptAdapter
  describe ExecEvalScriptAdapter ,:focus do
    subject { described_class.new base }
    let(:base) { spy('driver') }

    describe "#execute_script" do
      it "should delegate to base" do
        subject.execute_script :foo
        expect(base).to have_received(:execute_script).with(:foo)
      end

      it "should return nil regardless what base returns" do
        allow(base).to receive(:execute_script).and_return(:bar)
        expect(subject.execute_script :foo).to be_nil
      end
    end

    describe "#evaluate_script" do
      it "should delegate to base.execute_script" do
        subject.evaluate_script :foo
        expect(base).to have_received(:execute_script)
      end

      it "should wrap with 'return'" do
        subject.evaluate_script :foo
        expect(base).to have_received(:execute_script).with("return foo")
      end

      it "should return the value from execute_script" do
        allow(base).to receive(:execute_script).and_return(:bar)
        expect(subject.evaluate_script :foo).to eq :bar
      end
    end

    describe "::wrap" do
      let(:base) { double('driver') }

      context "when base doesn't respond to #execute_script" do
        it "should raise an error" do
          expect { described_class.wrap base }.to raise_error(WebDriverError)
        end
      end

      context "when base doesn't respond to #evaluate_script" do
        before :each do
          allow(base).to receive(:execute_script)
        end

        it "should wrap the base in the adapter" do
          expect(described_class).to receive(:new).with(base)
          described_class.wrap base
        end
      end

      context "when base already responds to #evaluate_script" do
        before :each do
          allow(base).to receive(:execute_script)
          allow(base).to receive(:evaluate_script)
        end

        it "should return base unmodified" do
          expect(described_class).not_to receive(:new)
          expect(described_class.wrap base).to be base
        end
      end
    end
  end
end
