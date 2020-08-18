require "capybara"
require "selenium-webdriver"
require "watir"
require_relative "../../lib/webdriver_script_adapter/exec_eval_script_adapter"

module WebDriverScriptAdapter
  describe ExecEvalScriptAdapter do
    subject { described_class.new driver }
    let(:driver) { spy("driver", execute_script: :bar) }

    describe "#execute_script" do
      it "should delegate to driver" do
        subject.execute_script :foo
        expect(driver).to have_received(:execute_script).with(:foo)
      end

      it "should return nil regardless what driver returns" do
        expect(subject.execute_script :foo).to be_nil
      end
    end

    describe "#evaluate_script" do
      it "should delegate to driver.execute_script" do
        subject.evaluate_script :foo
        expect(driver).to have_received(:execute_script)
      end

      it "should wrap with 'return'" do
        subject.evaluate_script :foo
        expect(driver).to have_received(:execute_script).with("return foo")
      end

      it "should return the value from execute_script" do
        expect(subject.evaluate_script :foo).to eq :bar
      end
    end

    describe "::wrap", :integration, :slow do
    

      shared_examples "a webdriver" do
        it "should wrap the driver in the adapter" do
          expect(described_class).to receive(:new).with(driver)
          described_class.wrap driver
        end
      end

      context "Capybara (already responds to #evaluate_script)" do
        let(:driver) { Capybara.current_session }

        it "should return driver unmodified" do
          expect(described_class).not_to receive(:new)
          expect(described_class.wrap driver).to be driver
        end
      end

      context "Other (doesn't respond to #execute_script)" do
        let(:driver) { double("driver") }
        it "should raise an error" do
          expect { described_class.wrap driver }.to raise_error(WebDriverError)
        end
      end
    end
  end
end
