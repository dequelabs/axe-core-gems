require 'axe/page'

# capybara (with webkit)
require 'capybara'
require 'capybara-webkit'
Capybara.current_driver = :webkit

# selenium
require 'selenium-webdriver'

# watir
require 'watir-webdriver'

module Axe
  describe Page, :integration, :slow do
    let(:subject) { described_class.new driver }

    context "Capybara" do
      let(:driver) { Capybara.current_session }

      describe "#evaluate" do
        it "should delegate directly to the browser/webdriver" do
          expect(driver).to receive(:evaluate_script).with("foo").and_return("bar")
          expect(subject.evaluate("foo")).to eq("bar")
        end
      end

      describe "#execute_script" do
        it "should delegate directly to the browser/webdriver" do
          expect(driver).to receive(:execute_script).with("foo").and_return("bar")
          expect(subject.execute_script("foo")).to eq("bar")
        end
      end
    end

    shared_examples "a webdriver" do
      describe "#evaluate" do
        it "should wrap in return and delegate to execute_script" do
          expect(driver).to receive(:execute_script).with("return foo").and_return("bar")
          expect(subject.evaluate("foo")).to eq("bar")
        end
      end

      describe "#execute_script" do
        it "should delegate directly to execute_script but not return anything" do
          expect(driver).to receive(:execute_script).with("foo").and_return("bar")
          expect(subject.execute_script("foo")).to be_nil
        end
      end
    end

    context "Selenium" do
      it_behaves_like "a webdriver" do
        let(:driver) { Selenium::WebDriver.for :phantomjs }
      end
    end

    context "Watir" do
      it_behaves_like "a webdriver" do
        let(:driver) { Watir::Browser.new :phantomjs }
      end
    end

  end
end
