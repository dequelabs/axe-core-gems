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
        audit page do |results|
          Audit.new to_js, Results.new(results)
        end
      end

      def analyze_post_43x(page, lib)
        @original_window = window_handle page
        partial_results = run_partial_recursive(page, @context, lib, true)
        throw partial_results if partial_results.respond_to?("key?") and partial_results.key?("errorMessage")
        results = within_about_blank_context(page) { |page|
          Common::Loader.new(page, lib).load_top_level Axe::Configuration.instance.jslib
          axe_finish_run page, partial_results
        }
        Audit.new to_js, Results.new(results)
      end

      private

      def audit(page)
        script = <<-JS
          var callback = arguments[arguments.length - 1];
          var callback = arguments[arguments.length - 1];
          context = arguments[0] || document;
          var options = arguments[1];
          var p = #{METHOD_NAME}.apply(#{Core::JS_NAME}, [context, options]);
          if (p) {
            p.then(callback);
          }
        JS

        # yield page.execute_async_script "#{METHOD_NAME}.apply(#{Core::JS_NAME}, arguments)", *js_args
        # "#{METHOD_NAME}.apply(#{Core::JS_NAME}, arguments)"
        yield page.execute_async_script script, *js_args
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

        driver.execute_script("window.open('about:blank'), '_blank'")
        driver.switch_to.window page.window_handles[-1]
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

      def run_partial_recursive(page, context, lib, top_level = false)
        begin
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
          if res.key?("errorMessage")
            throw res if top_level
            return [nil]
          else
            results = [res]
          end

          for frame_context in frame_contexts
            frame_selector = frame_context["frameSelector"]
            frame_context = frame_context["frameContext"]
            frame = axe_shadow_select page, frame_selector
            switch_to_frame_by_handle page, frame
            res = run_partial_recursive page, frame_context, lib
            results += res
          end

        ensure
          switch_to_parent_frame page if not top_level
        end
        return results
      end

      def axe_finish_run(page, partial_results)
        script = <<-JS
          const partialResults = arguments[0];
          return axe.finishRun(partialResults);
        JS
        page.execute_script_fixed script, partial_results
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
            const ret = window.axe.runPartial(context, options);
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
          .reject(&:empty?)
          .map(&:to_json)
      end

      def to_js
        str_args = (js_args + ["callback"]).join(", ")
        "#{METHOD_NAME}(#{str_args});"
      end
    end
  end
end
