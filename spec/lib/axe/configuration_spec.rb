require 'spec_helper'
require 'axe/configuration'

module Axe
  describe Configuration do

    # cucumber config
    it { is_expected.to respond_to :page }
    it { is_expected.to respond_to :page= }
    # webdriver async config
    it { is_expected.to respond_to :async_results_identifier }
    it { is_expected.to respond_to :async_results_identifier= }
    it { is_expected.to respond_to :max_wait_time }
    it { is_expected.to respond_to :max_wait_time= }
    it { is_expected.to respond_to :wait_interval }
    it { is_expected.to respond_to :wait_interval= }



    describe "after_load hook" do
      context "with a single registered callback" do
        let(:after_load_block) { spy('after_load_block') }

        it "should call the block" do
          subject.after_load after_load_block

          subject.run_after_load_hook :args
          expect(after_load_block).to have_received(:call).with(:args)
        end
      end

      context "with multiple registered callbacks" do
        let(:after_load_block) { spy('after_load_block') }

        it "should call the block" do
          subject.after_load after_load_block
          subject.after_load after_load_block

          subject.run_after_load_hook :args
          expect(after_load_block).to have_received(:call).with(:args).twice
        end
      end

      it "should accept a block" do
        called = false
        subject.after_load { called=true }

        subject.run_after_load_hook :args
        expect(called).to be true
      end

      it "should accept a callable" do
        called = false
        subject.after_load ->(foo) { called=true }

        subject.run_after_load_hook :args
        expect(called).to be true
      end
    end

  end
end
