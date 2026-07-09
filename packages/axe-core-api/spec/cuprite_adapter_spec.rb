require "webdriver_script_adapter/cuprite_adapter"

RSpec.describe WebDriverScriptAdapter::CupriteBrowserFacade do
  let(:driver) do
    instance_double(
      "Capybara::Cuprite::Driver",
      visit: nil, execute_script: nil, window_handle: "win-1",
      window_handles: ["win-1"], switch_to_window: nil, close_window: nil,
      switch_to_frame: nil, timeout: 5
    )
  end
  subject(:facade) { described_class.new(driver) }

  it "maps get to Cuprite#visit" do
    facade.get("about:blank")
    expect(driver).to have_received(:visit).with("about:blank")
  end

  it "exposes a page_load timeout that round-trips (no-op backed)" do
    facade.manage.timeouts.page_load = 1
    expect(facade.manage.timeouts.page_load).to eq(1)
  end

  it "routes switch_to.window to Cuprite#switch_to_window" do
    facade.switch_to.window("win-2")
    expect(driver).to have_received(:switch_to_window).with("win-2")
  end

  it "routes switch_to.parent_frame to switch_to_frame(:parent)" do
    facade.switch_to.parent_frame
    expect(driver).to have_received(:switch_to_frame).with(:parent)
  end

  it "delegates execute_script with args to the driver" do
    facade.execute_script("return 1;", "a")
    expect(driver).to have_received(:execute_script).with("return 1;", "a")
  end

  it "closes the current window" do
    facade.close
    expect(driver).to have_received(:close_window).with("win-1")
  end
end

RSpec.describe WebDriverScriptAdapter::CupriteAdapter do
  let(:raw_driver) do
    instance_double(
      "Capybara::Cuprite::Driver",
      evaluate_async_script: nil
    )
  end
  let(:chain) { Object.new }
  subject(:adapter) { described_class.wrap(chain, raw_driver) }

  it "returns a CupriteBrowserFacade from #browser" do
    expect(adapter.browser).to be_a(WebDriverScriptAdapter::CupriteBrowserFacade)
  end

  it "wraps execute_script_fixed in an async shim and calls evaluate_async_script" do
    # Ferrum's evaluate_async_script uses awaitPromise: true, so both sync
    # values and Promise-returning scripts (e.g. axe.finishRun) are handled.
    allow(raw_driver).to receive(:evaluate_async_script).and_return([])
    result = adapter.execute_script_fixed("return window.axe.utils.getFrameContexts(arguments[0]);", { "include" => "#main" })
    expect(result).to eq([])
    # The original script body is embedded in the wrapper passed to evaluate_async_script.
    expect(raw_driver).to have_received(:evaluate_async_script)
      .with(a_string_including("return window.axe.utils.getFrameContexts(arguments[0]);"), { "include" => "#main" })
  end

  it "raises when the wrapper catches a JS exception" do
    allow(raw_driver).to receive(:evaluate_async_script)
      .and_return({ described_class::WRAPPER_ERROR_KEY => "boom" })

    expect { adapter.execute_script_fixed("throw new Error('boom');") }
      .to raise_error(WebDriverScriptAdapter::WebDriverError, /boom/)
  end

  it "passes a protocol errorMessage result through instead of raising" do
    # axe's getFrameContexts/runPartial return {errorMessage: ...} as data the
    # run.rb recursion inspects; the adapter must not intercept it.
    payload = { "errorMessage" => "frame boom" }
    allow(raw_driver).to receive(:evaluate_async_script).and_return(payload)

    expect(adapter.execute_script_fixed("return window.axe.utils.getFrameContexts(arguments[0]);"))
      .to eq(payload)
  end

  it "delegates execute_async_script_fixed directly to evaluate_async_script on the raw driver" do
    # Native evaluate_async_script uses Ferrum's evaluate_async with awaitPromise: true,
    # which correctly awaits a Promise passed to the callback (cb(promise) pattern).
    allow(raw_driver).to receive(:evaluate_async_script).and_return({ "violations" => [] })
    result = adapter.execute_async_script_fixed("axe.runPartial(arguments[0], arguments[1])", { "include" => "#main" }, {})
    expect(result).to eq({ "violations" => [] })
    expect(raw_driver).to have_received(:evaluate_async_script)
      .with("axe.runPartial(arguments[0], arguments[1])", { "include" => "#main" }, {})
  end

  describe "#assert_context_supported!" do
    it "raises for multi-element inclusion selectors" do
      expect {
        adapter.assert_context_supported!({ "include" => [["#child", "#bad"]] })
      }.to raise_error(WebDriverScriptAdapter::WebDriverError, /Multi-element selectors/)
    end

    it "raises for multi-element exclusion selectors with symbol keys" do
      expect {
        adapter.assert_context_supported!({ exclude: [["#child", "#bad"]] })
      }.to raise_error(WebDriverScriptAdapter::WebDriverError, /Multi-element selectors/)
    end

    it "does not recommend skip_iframes in the multi-element selector message" do
      # The selector check fires BEFORE the skip_iframes gate, so skip_iframes
      # cannot bypass it — the message must not suggest otherwise.
      expect {
        adapter.assert_context_supported!({ "include" => [["#child", "#bad"]] }, true)
      }.to raise_error(WebDriverScriptAdapter::WebDriverError) { |e|
        expect(e.message).not_to match(/skip_iframes=true to audit/)
      }
    end

    it "allows top-level selector contexts when the document has no frames" do
      allow(raw_driver).to receive(:evaluate_async_script).and_return(0)

      expect {
        adapter.assert_context_supported!({ "include" => ["#main"] })
      }.not_to raise_error
    end

    it "raises when the current document contains frames" do
      allow(raw_driver).to receive(:evaluate_async_script).and_return(1)

      expect {
        adapter.assert_context_supported!({ "exclude" => [] })
      }.to raise_error(WebDriverScriptAdapter::WebDriverError, /iframe auditing is not supported/)
    end

    it "allows current document frames when skip_iframes is enabled" do
      expect {
        adapter.assert_context_supported!({ "exclude" => [] }, true)
      }.not_to raise_error
      expect(raw_driver).not_to have_received(:evaluate_async_script)
    end
  end

  it "delegates unknown methods to the wrapped chain" do
    def chain.evaluate_script(_script)
      "chained"
    end

    expect(adapter.evaluate_script("window.axe")).to eq("chained")
  end

  describe ".cuprite_driver?" do
    it "is false for a non-cuprite object" do
      expect(described_class.cuprite_driver?(Object.new)).to be(false)
    end
  end
end
