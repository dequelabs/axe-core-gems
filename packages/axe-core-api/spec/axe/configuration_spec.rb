require "spec_helper"
require "tempfile"

require_relative "../../lib/axe/configuration"

module Axe
  describe Configuration do
    subject { described_class.instance }

    # axe config
    it { is_expected.to respond_to :jslib }
    it { is_expected.to respond_to :jslib= }
    it { is_expected.to respond_to :jslib_path }
    it { is_expected.to respond_to :jslib_path= }
    it { is_expected.to respond_to :skip_iframes }
    it { is_expected.to respond_to :skip_iframes= }

    # webdriver async config
    it { is_expected.to respond_to :async_results_identifier }
    it { is_expected.to respond_to :async_results_identifier= }
    it { is_expected.to respond_to :max_wait_time }
    it { is_expected.to respond_to :max_wait_time= }
    it { is_expected.to respond_to :wait_interval }
    it { is_expected.to respond_to :wait_interval= }

    # check for contents of axe
    its(:jslib) {
      is_expected.to include("axe.run=")
    }

    # check if hooks (included)
    describe "#after_load hook" do
      let(:after_load_block) { spy("after_load_block") }

      after :each do
        # reset the shared callbacks hash for each test
        Common::Hooks.instance_variable_set :@callbacks, nil
      end

      context "with a single registered callback" do
        it "should call the block" do
          subject.after_load after_load_block

          Common::Hooks.run_after_load :args
          expect(after_load_block).to have_received(:call).with(:args)
        end
      end

      context "with multiple registered callbacks" do
        it "should call the block" do
          subject.after_load after_load_block
          subject.after_load after_load_block

          Common::Hooks.run_after_load :args
          expect(after_load_block).to have_received(:call).with(:args).twice
        end
      end

      it "should accept a block" do
        called = false
        subject.after_load { called = true }

        Common::Hooks.run_after_load :args
        expect(called).to be true
      end

      it "should accept a callable" do
        called = false
        subject.after_load ->(foo) { called = true }

        Common::Hooks.run_after_load :args
        expect(called).to be true
      end
    end
  end
end
