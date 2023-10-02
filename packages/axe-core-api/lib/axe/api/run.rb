require "forwardable"
require "json"

require_relative "../../chain_mail/chainable"
require_relative "./audit"
require_relative "./context"
require_relative "./options"
require_relative "./results"
require_relative "../core"

module Axe
  module API
    class Run
      JS_NAME = "run"
      METHOD_NAME = "#{Core::JS_NAME}.#{JS_NAME}"

      extend Forwardable
      def_delegators :@context, :within, :excluding
      def_delegators :@options, :according_to, :checking, :checking_only, :skipping, :with_options

      extend ChainMail::Chainable
      chainable :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def call(page)
        results = audit page
        Audit.new to_js, Results.new(results)
      end

      def analyze_post_43x(page, lib)
        user_page_load = (get_selenium page).manage.timeouts.page_load
        (get_selenium page).manage.timeouts.page_load = 1
        begin
          @original_window = window_handle page
          partial_results = run_partial_recursive(page, @context, lib, true)
          throw partial_results if partial_results.respond_to?("key?") and partial_results.key?("errorMessage")
          results = within_about_blank_context(page) { |page|
            partial_res_str = partial_results.to_json
            size_limit = 10_000_000
            while not partial_res_str.empty? do
              chunk_size = size_limit
              chunk_size = partial_res_str.length if chunk_size > partial_res_str.length
              chunk = partial_res_str[0..chunk_size-1]
              partial_res_str = partial_res_str[chunk_size..-1]
              store_chunk page, chunk
            end
  
            Common::Loader.new(page, lib).load_top_level Axe::Configuration.instance.jslib
            begin
              axe_finish_run page
            rescue
              raise StandardError.new "axe.finishRun failed. Please check out https://github.com/dequelabs/axe-core-gems/blob/develop/error-handling.md"
            end
  
          }
        ensure
          (get_selenium page).manage.timeouts.page_load = user_page_load
        end
        Audit.new to_js, Results.new(results)
      end

      private

      def audit(page)
        script = <<-JS
          var callback = arguments[arguments.length - 1];
          var context = arguments[0] || document;
          var options = arguments[1] || {};
          #{METHOD_NAME}(context, options).then(res => JSON.parse(JSON.stringify(res))).then(callback);
        JS
        page.execute_async_script_fixed script, *js_args
      end

      def switch_to_frame_by_handle(page, handle)
        page = get_selenium page
        page.switch_to.frame handle
      end

      def switch_to_parent_frame(page)
        page = get_selenium page
        page.switch_to.parent_frame
      end

      def within_about_blank_context(page)
        driver = get_selenium page

        num_handles = page.window_handles.length
        begin
          driver.execute_script("window.open('about:blank'), '_blank'")
          if num_handles == page.window_handles.length
            raise StandardError.new "Could not open new window. Please make sure that you have popup blockers disabled."
          end
          driver.switch_to.window page.window_handles[-1]
        rescue
            raise StandardError.new "switchToWindow failed. Are you using updated browser drivers? Please check out https://github.com/dequelabs/axe-core-gems/blob/develop/error-handling.md"
        end
        driver.get "about:blank"

        ret = yield page

        driver.switch_to.window page.window_handles[-1]
        driver.close
        driver.switch_to.window @original_window

        ret
      end
      def window_handle(page)
        page = get_selenium page

        return page.window_handle if page.respond_to?("window_handle")
        page.current_window_handle
      end

      def run_partial_recursive(page, context, lib, top_level = false, frame_stack = [])
        begin
          current_window_handle = window_handle page
          if not top_level
            begin
              Common::Loader.new(page, lib).load_top_level Axe::Configuration.instance.jslib
            rescue
              return [nil]
            end
          end

          frame_contexts = get_frame_context_script page
          if frame_contexts.respond_to?("key?") and frame_contexts.key?("errorMessage")
            throw frame_contexts if top_level
            return [nil]
          end

          res = axe_run_partial page, context
          if res.nil? || res.key?("errorMessage")
            if top_level
              throw res unless res.nil?
              throw "axe.runPartial returned null"
            end
            return [nil]
          else
            results = [res]
          end

          for frame_context in frame_contexts
            begin
              frame_selector = frame_context["frameSelector"]
              frame_context = frame_context["frameContext"]
              frame = axe_shadow_select page, frame_selector
              switch_to_frame_by_handle page, frame
              res = run_partial_recursive page, frame_context, lib, false, [*frame_stack, frame]
              results += res
            rescue Selenium::WebDriver::Error::TimeoutError
              page = get_selenium page
              page.switch_to.window current_window_handle
              frame_stack.each {|frame| page.switch_to.frame frame }
              results.push nil
            end
          end

        ensure
          switch_to_parent_frame page if not top_level
        end
        return results
      end

      def store_chunk(page, chunk)
        script = <<-JS
          const chunk = arguments[0];
          window.partialResults ??= '';
          window.partialResults += chunk;
        JS
        page.execute_script_fixed script, chunk
      end
      def axe_finish_run(page)
        script = <<-JS
          const partialResults = JSON.parse(window.partialResults || '[]');
          return axe.finishRun(partialResults);
        JS
        page.execute_script_fixed script
      end

      def axe_shadow_select(page, frame_selector)
        script = <<-JS
          const frameSelector = arguments[0];
          return axe.utils.shadowSelect(frameSelector);
        JS
        page.execute_script_fixed script, frame_selector
      end

      def axe_run_partial(page, context)
        script = <<-JS
          const context = arguments[0];
          const options = arguments[1];
          const cb = arguments[arguments.length - 1];
          try {
            const ret = window.axe.runPartial(context, options).then(res => JSON.parse(JSON.stringify(res)));
            cb(ret);
          } catch (err) {
            const ret = {
              violations: [],
              passes: [],
              url: '',
              timestamp: new Date().toString(),
              errorMessage: err.message
            };
            cb(ret);
          }
        JS
        page.execute_async_script_fixed script, context, @options
      end

      def get_frame_context_script(page)
        script = <<-JS
          const context = arguments[0];
          try {
            return window.axe.utils.getFrameContexts(context);
          } catch (err) {
            return {
              violations: [],
              passes: [],
              url: '',
              timestamp: new Date().toString(),
              errorMessage: err.message
            };
          }
        JS
        page.execute_script_fixed script, @context
      end

      def get_selenium(page)
        page = page.driver if page.respond_to?("driver")
        page = page.browser if page.respond_to?("browser") and not page.browser.is_a?(::Symbol)
        page
      end

      def js_args
        [@context, @options]
          .map(&:to_h)
      end

      def to_js
        str_args = (js_args + ["callback"]).join(", ")
        "#{METHOD_NAME}(#{str_args});"
      end
    end
  end
end
