require "dumb_delegator"
require_relative "./exec_eval_script_adapter"

module WebDriverScriptAdapter
  # Presents the Selenium-shaped surface that Axe::API::Run#analyze_post_43x
  # expects, backed by a Capybara::Cuprite::Driver. This is the object
  # run.rb's #get_selenium resolves to (via CupriteAdapter#browser).
  class CupriteBrowserFacade
    Timeouts = Struct.new(:page_load)

    class Manage
      def initialize(driver)
        # Seed page_load from Cuprite's command timeout; value is only ever
        # read back and restored by run.rb, so a stored attr is sufficient and
        # avoids perturbing CDP behaviour (about:blank loads instantly).
        @timeouts = Timeouts.new(driver.respond_to?(:timeout) ? driver.timeout : 1)
      end

      def timeouts
        @timeouts
      end
    end

    class SwitchTo
      def initialize(driver)
        @driver = driver
      end

      def window(handle)
        @driver.switch_to_window(handle)
      end

      def frame(handle)
        @driver.switch_to_frame(handle)
      end

      def parent_frame
        @driver.switch_to_frame(:parent)
      end

      def default_content
        @driver.switch_to_frame(:top)
      end
    end

    def initialize(driver)
      @driver = driver
      @manage = Manage.new(driver)
      @switch_to = SwitchTo.new(driver)
    end

    def manage
      @manage
    end

    def switch_to
      @switch_to
    end

    def get(url)
      @driver.visit(url)
    end

    def execute_script(script, *args)
      @driver.execute_script(script, *args)
    end

    def window_handle
      @driver.window_handle
    end
    alias current_window_handle window_handle

    def window_handles
      @driver.window_handles
    end

    def close
      @driver.close_window(@driver.window_handle)
    end
  end

  # Outermost decorator in the wrap chain for Cuprite drivers. Holds a ref to
  # the RAW Cuprite driver (not the wrapped chain) so #browser and the *_fixed
  # methods bypass the Selenium-native assumptions baked into the inner chain.
  class CupriteAdapter < ::DumbDelegator
    # Raised when the CURRENT document contains frames. skip_iframes DOES bypass
    # this (it audits only the top-level document), so recommending it is correct.
    UNSUPPORTED_IFRAME_MESSAGE = "Cuprite iframe auditing is not supported yet. " \
      "Set Axe::Configuration#skip_iframes=true to audit only the top-level document, " \
      "or use a Selenium-backed driver for iframe audits."

    # Raised for multi-element context selectors. axe uses the nested-array form for
    # BOTH iframe chains and shadow-DOM piercing, so this rejection is conservative:
    # it fires before the skip_iframes gate (a frame-targeting selector still can't
    # be honoured under skip_iframes), which is why it must NOT recommend skip_iframes.
    # Whole-page and single-selector audits already pierce open shadow DOM
    # automatically; only element-scoped shadow targeting via this syntax is blocked.
    UNSUPPORTED_IFRAME_SELECTOR_MESSAGE = "Multi-element selectors " \
      "(e.g. [['#outer', '#inner']]) are treated as iframe selectors, which Cuprite " \
      "cannot audit yet. axe still pierces open shadow DOM automatically for whole-page " \
      "and single-selector audits; to scope to a specific shadow-DOM-nested element via " \
      "this syntax, use a Selenium-backed driver for now. (skip_iframes does not bypass " \
      "this check.)"

    def self.cuprite_driver?(driver)
      !!(defined?(::Capybara::Cuprite::Driver) && driver.is_a?(::Capybara::Cuprite::Driver))
    end

    def self.wrap(wrapped, driver)
      new(wrapped, driver)
    end

    def initialize(wrapped, driver)
      super(wrapped)
      @driver = driver
    end

    # run.rb#get_selenium drills to `.browser`; hand it the Selenium facade
    # instead of the raw Capybara::Cuprite::Browser.
    def browser
      @facade ||= CupriteBrowserFacade.new(@driver)
    end

    # Cuprite's execute_script (Ferrum#execute) discards the return value.
    # Wrap the script body in an async shim so that:
    #   - `return` statements work inside the original script body.
    #   - Promise-returning scripts (e.g. axe.finishRun) are awaited via
    #     Promise.resolve, because Ferrum's evaluate_async uses awaitPromise:true.
    # The Ferrum template appends its resolve-callback as the last argument,
    # so we split user args from the callback before re-applying.
    # Sentinel key for exceptions caught by the wrapper below. Deliberately
    # distinct from axe's protocol "errorMessage" (which get_frame_context_script
    # and axe_run_partial return as data the recursion inspects) so that a
    # genuine JS throw here raises, while a legitimate {errorMessage: ...} result
    # flows back to run.rb's throw/return-[nil] control flow unchanged.
    WRAPPER_ERROR_KEY = "__cupriteWrapperError"

    def execute_script_fixed(script, *args)
      wrapper = <<~JS
        var __args = Array.prototype.slice.call(arguments, 0, arguments.length - 1);
        var __cb  = arguments[arguments.length - 1];
        try {
          var __result = (function() { #{script} }).apply(this, __args);
          Promise.resolve(__result).then(__cb).catch(function(e) {
            __cb({ #{WRAPPER_ERROR_KEY}: e.message });
          });
        } catch(e) {
          __cb({ #{WRAPPER_ERROR_KEY}: e.message });
        }
      JS
      result = @driver.evaluate_async_script(wrapper, *args)
      if result.respond_to?(:key?) && result.key?(WRAPPER_ERROR_KEY)
        raise WebDriverError, result[WRAPPER_ERROR_KEY]
      end

      result
    end

    # Use Cuprite's native evaluate_async_script (Ferrum evaluate_async with
    # awaitPromise: true) so that `cb(promise)` calls — the pattern axe's
    # runPartial script uses — are properly awaited rather than resolving
    # immediately to the Promise object (which the polling polyfill cannot
    # handle).
    def execute_async_script_fixed(script, *args)
      @driver.evaluate_async_script(script, *args)
    end

    def assert_context_supported!(context, skip_iframes = false)
      raise_unsupported_iframe_selector! if iframe_context?(context)
      return if skip_iframes

      assert_current_document_has_no_frames!
    end

    private

    def assert_current_document_has_no_frames!
      script = "return document.querySelectorAll('iframe, frame').length;"
      raise_unsupported_iframe! if execute_script_fixed(script).to_i > 0
    end

    def iframe_context?(context)
      selectors = Array(context_value(context, "include")) + Array(context_value(context, "exclude"))
      selectors.any? { |selector| selector.is_a?(::Array) && selector.length > 1 }
    end

    def context_value(context, key)
      context[key] || context[key.to_sym]
    end

    def raise_unsupported_iframe!
      raise WebDriverError, UNSUPPORTED_IFRAME_MESSAGE
    end

    def raise_unsupported_iframe_selector!
      raise WebDriverError, UNSUPPORTED_IFRAME_SELECTOR_MESSAGE
    end
  end
end
