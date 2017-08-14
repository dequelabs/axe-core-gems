require 'webdriver_script_adapter/execute_async_script_adapter'

module WebDriverScriptAdapter
  describe ExecuteAsyncScriptAdapter do
    subject { described_class.new driver }
    let(:driver) { spy('driver') }

    describe "#execute_async_script" do
      it "should delegate to #execute_script" do
        subject.execute_async_script :foo
        expect(driver).to have_received(:execute_script)
      end

      it "should wrap the script in an anonymous function" do
        subject.execute_async_script :foo
        expect(driver).to have_received(:execute_script).with a_string_starting_with "(function(){ foo })"
      end

      it "should pass along provided arguments to the anonymous function (unescaped for now)" do
        subject.execute_async_script :foo, :a, 1, '2'
        expect(driver).to have_received(:execute_script).with a_string_matching "(a, 1, 2)"
      end

      it "should pass a callback as the last argument" do
        subject.execute_async_script :foo
        expect(driver).to have_received(:execute_script).with a_string_matching(/function\(err, returnValue\){ window\['.*'\] = \(err \|\| returnValue\); \}\)/)
      end

      it "should attempt to evaluate the stored async results" do
        subject.execute_async_script :foo
        expect(driver).to have_received(:evaluate_script).with a_string_matching(/window\['.*'\]/)
      end

      context "with configured result identifier" do
        before :each do
          WebDriverScriptAdapter.configure do |c|
            c.async_results_identifier = -> { :foo }
          end
        end

        it "should use the configured result identifier in the callback" do
          subject.execute_async_script :foo
          expect(driver).to have_received(:execute_script).with a_string_ending_with "function(err, returnValue){ window['foo'] = (err || returnValue); });"
        end

        it "should use the configured result identifier in the callback" do
          subject.execute_async_script :foo
          expect(driver).to have_received(:evaluate_script).with "window['foo']"
        end
      end

      it "should return the final evaluated results" do
        allow(driver).to receive(:evaluate_script).and_return(:foo)
        expect(subject.execute_async_script :bar).to be :foo
      end

      it "should treat `false` as a valid return value" do
        allow(driver).to receive(:evaluate_script).and_return(false)
        expect(subject.execute_async_script :foo).to be false
      end

      it "should retry until the results are ready", :slow do
        nil_invocations = Array.new(5, nil)
        allow(driver).to receive(:evaluate_script).and_return(*nil_invocations, :foo)
        expect(subject.execute_async_script :bar).to be :foo
      end

      it "should timeout if results aren't ready after some time", :slow do
        allow(driver).to receive(:evaluate_script) { sleep(5) and :foo }
        expect { subject.execute_async_script :bar }.to raise_error Timeout::Error
      end
    end

    describe "::wrap" do
      it "should wrap with ExecEval first" do
        expect(ExecEvalScriptAdapter).to receive(:wrap).with(driver)
        described_class.wrap driver
      end

      it "should wrap with the adapter" do
        allow(ExecEvalScriptAdapter).to receive(:wrap).and_return(:foo)
        expect(described_class).to receive(:new).with(:foo)
        described_class.wrap driver
      end
    end
  end
end
