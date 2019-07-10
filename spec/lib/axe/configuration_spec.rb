require 'tempfile'
require 'spec_helper'
require 'axe/configuration'

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

    # We have removed comments from `axe.min.js`, so excluding this test
    # Hence cannot do start_with("/*! aXe"), instead do a function we know should exist check
    its(:jslib) {
      is_expected.to include("axe.run=function(")
    }

    describe "#after_load hook" do
      let(:after_load_block) { spy('after_load_block') }

      after :each do
        # reset the shared callbacks hash for each test
        Hooks.instance_variable_set :@callbacks, nil
      end

      context "with a single registered callback" do
        it "should call the block" do
          subject.after_load after_load_block

          Hooks.run_after_load :args
          expect(after_load_block).to have_received(:call).with(:args)
        end
      end

      context "with multiple registered callbacks" do
        it "should call the block" do
          subject.after_load after_load_block
          subject.after_load after_load_block

          Hooks.run_after_load :args
          expect(after_load_block).to have_received(:call).with(:args).twice
        end
      end

      it "should accept a block" do
        called = false
        subject.after_load { called = true }

        Hooks.run_after_load :args
        expect(called).to be true
      end

      it "should accept a callable" do
        called = false
        subject.after_load ->(foo) { called = true }

        Hooks.run_after_load :args
        expect(called).to be true
      end
    end

    describe "::from_yaml" do
      context "when file exists" do
        let(:yaml_file) do
          Tempfile.new("temp.yml").tap do |f|
            f.write %Q{---\npage: foo}
            f.close
          end
        end

        it "should load from given yaml file" do
          described_class.from_yaml(yaml_file)
          expect(subject.page).to eq "foo"
        end
      end

      context "when file doesn't exist" do
        let(:yaml_file) { "does-not-exist.txt" }

        it "should silently skip" do
          expect { described_class.from_yaml(yaml_file) }.to_not raise_error
        end
      end
    end
  end
end
