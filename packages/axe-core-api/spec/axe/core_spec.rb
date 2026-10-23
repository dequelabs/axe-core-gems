require_relative "../../lib/axe/core"

module Axe
  describe Core do
    subject(:core) { described_class.new(page) }

    let(:page) {
      spy("page", evaluate_script: false)
    }
    before { allow(page).to receive(:evaluate_script).and_return(false) }
    describe "initialize" do
      # We have removed comments from `axe.min.js`, so excluding this test
      # Hence cannot do start_with("/*! aXe"), instead do a function we know should exist check
      it "should inject the axe-core lib" do
        described_class.new(page)
        expect(page).to have_received(:execute_script).with(a_string_including ("axe.run="))
      end

      context "when axe-core exists in the page" do
        before { allow(page).to receive(:evaluate_script).and_return(true) }

        it "should not inject the axe-core lib" do
          described_class.new(page)
          expect(page).not_to have_received(:execute_script)
        end
      end

      context "when document.readyState is interactive" do
        before { allow(page).to receive(:evaluate_script).and_return(false, 'interactive', 'interactive', 'complete') }
        it "should check ready frame until complete, then proceed" do
          described_class.new(page)
          expect(page).to have_received(:execute_script).with(a_string_including ("axe.run="))
        end
      end
    end

    describe "call" do
      let(:run) { spy("run") }

      it "should invoke the callable in the page" do
        core.call(run)

        expect(run).to have_received(:call).with(page)
      end
    end

    describe "call with axe.runPartial" do
      let(:run) { spy("run") }
      before { allow(page).to receive(:evaluate_script).and_return(false, true) }

      it "should not load axe into frames" do
        core.call(run)

        expect(run).to have_received(:analyze_post_43x)
        expect(page).not_to have_received(:find_css).with("iframe")
      end
    end

    describe "call in legacy mode" do
      let(:run) { spy("run") }

      it "should not load axe into frames when iframes is false" do
        allow(run).to receive(:iframes?).and_return(false)
        core.call(run)

        expect(page).not_to have_received(:find_css).with("iframe")
        expect(run).to have_received(:call).with(page)
      end

      it "should load axe into frames when iframes is not false" do
        core.call(run)

        expect(page).to have_received(:find_css).with("iframe")
      end

      it "should load axe into frames when axe is already in the top frame" do
        allow(page).to receive(:evaluate_script).and_return(true, false)
        core.call(run)

        expect(page).to have_received(:find_css).with("iframe")
        expect(page).not_to have_received(:execute_script).with(Axe::Configuration.instance.jslib)
      end

      it "should load axe into frames only once for two calls" do
        core.call(run)
        core.call(run)

        expect(page).to have_received(:find_css).with("iframe").once
      end

      it "should load axe into frames on a later call when skip_iframes was set" do
        allow(Axe::Configuration.instance).to receive(:skip_iframes).and_return(true, false)
        core.call(run)
        core.call(run)

        expect(page).to have_received(:find_css).with("iframe").once
      end

      it "should load axe into frames on a later call after a call with iframes false" do
        no_frames = spy("run without frames", iframes?: false)
        core.call(no_frames)
        core.call(run)

        expect(page).to have_received(:find_css).with("iframe").once
      end

      context "with an after_load hook that calls call" do
        let(:inner_run) { spy("inner run") }
        let(:hook) {
          lambda do |lib|
            raise "after_load recursed" if hooks_run.length > 10
            hooks_run << lib
            lib.call inner_run
          end
        }
        let(:hooks_run) { [] }
        before { Common::Hooks.callbacks[:after_load] << hook }
        after { Common::Hooks.callbacks[:after_load].delete hook }

        it "should not recurse" do
          expect { core.call(run) }.not_to raise_error
          expect(run).to have_received(:call).with(page)
        end
      end

      context "with an after_load hook that calls call_verbatim" do
        let(:configure) { spy("configure") }
        let(:hook) {
          lambda do |lib|
            raise "after_load recursed" if hooks_run.length > 10
            hooks_run << lib
            lib.call_verbatim configure
          end
        }
        let(:hooks_run) { [] }
        before { Common::Hooks.callbacks[:after_load] << hook }
        after { Common::Hooks.callbacks[:after_load].delete hook }

        it "should run the hook once on load and once on the first call" do
          core.call(run)
          core.call(run)

          expect(hooks_run.length).to be 2
          expect(configure).to have_received(:call).with(page).twice
        end
      end
    end

    describe "call_verbatim" do
      let(:run) { spy("run") }

      it "should invoke the callable in the page" do
        core.call_verbatim(run)

        expect(run).to have_received(:call).with(page)
      end
    end
  end
end
