require "spec_helper"
require "capybara/rspec"

require_relative "../lib/axe-capybara"

describe AxeCapybara do
  subject { described_class }

  describe "driver" do
    it "validate yielded configuration" do
      driver = AxeCapybara.configure(:firefox) do
      end

      expect(driver).not_to be_nil
      driver.page.visit "https://google.com" # can navigate
      expect(driver).to respond_to :skip_iframes # can config
      expect(driver).to respond_to :jslib
      expect(driver.jslib).to include("axe.run=") # has axe injected
    end
  end

  describe "#configure" do
    it "should yield default configuration" do
      actual = Axe::Configuration.instance
      expect { |stub_block|
        subject.configure(&stub_block)
      }.to yield_with_args(actual)
    end

    # Default is firefox, so we can just check that we can override the default
    it "sets browser" do
      driver = AxeCapybara.configure(:chrome) do
      end
      is_chrome = driver.page.execute_script "return !!window.chrome"
      expect(is_chrome).to be true
    end

    it "defaults to firefox" do
      driver = AxeCapybara.configure() do
      end
      browser = driver.page.options[:browser]
      expect(browser).to be :firefox
    end
    it "sets browser correctly" do
      driver = AxeCapybara.configure(:chrome) do
      end
      browser = driver.page.options[:browser]
      expect(browser).to be :chrome
    end

    it "should yield configuration with specified jslib path" do
      different_axe_path = "different-axe-path/axe.js"

      # configure:
      # 1. driver for browser
      # 2. a different js path
      AxeCapybara.configure do |c|
        c.jslib_path = different_axe_path
      end

      actual = Axe::Configuration.instance
      expect(actual.jslib_path).to eq different_axe_path
    end

    it "should yield configuration with Chrome driver" do
      AxeCapybara.configure(:chrome) do
      end

      actual = Axe::Configuration.instance
      expect(actual.page).not_to be_nil
      expect(actual.page.to_s).to include("Capybara::Selenium::Driver")
    end

    it "should raise when no configuration block is provided" do
      expect { AxeCapybara.configure }.to raise_error("Please provide a configure block for AxeCapybara")
    end
  end
end
