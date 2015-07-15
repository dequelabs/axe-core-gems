require 'rspec/a11y/page'

module RSpec::A11y
  describe Page do
    let(:subject) { described_class.new browser }
    let(:browser) { double('browser') }

    context "Capybara-like API" do
      before :each do
        allow(browser).to receive(:evaluate_script)
        allow(browser).to receive(:execute_script)
      end

      describe "#evaluate" do
        it "should delegate directly to the browser/webdriver" do
          expect(browser).to receive(:evaluate_script).with("foo").and_return("bar")
          expect(subject.evaluate("foo")).to eq("bar")
        end
      end

      describe "#execute" do
        it "should delegate directly to the browser/webdriver" do
          expect(browser).to receive(:execute_script).with("foo").and_return("bar")
          expect(subject.execute("foo")).to eq("bar")
        end
      end
    end

    context "WebDriver-like API" do
      before :each do
        allow(browser).to receive(:execute_script).and_return("bar")
      end

      describe "#evaluate" do
        it "should wrap in return and delegate to execute_script" do
          subject.evaluate("foo")
          expect(browser).to have_received(:execute_script).with("return foo")
        end

        it "should return value" do
          expect(subject.evaluate("foo")).to eq("bar")
        end
      end

      describe "#execute" do
        it "should delegate directly to execute_script" do
          subject.execute("foo")
          expect(browser).to have_received(:execute_script).with("foo")
        end

        it "should not return value" do
          expect(subject.execute("foo")).to be_nil
        end
      end
    end
  end
end
