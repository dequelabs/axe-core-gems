require "spec_helper"
require_relative "../../../lib/axe/api/run"

module Axe::API
  describe Run do
    describe "@context" do
      let(:context) { spy("context") }
      before :each do
        subject.instance_variable_set :@context, context
      end

      it "should be delegated #within" do
        subject.within :foo
        expect(context).to have_received(:within).with(:foo)
      end

      it "should be delegated #excluding" do
        subject.excluding :foo
        expect(context).to have_received(:excluding).with(:foo)
      end
    end

    describe "@options" do
      let(:options) { spy("options") }
      before :each do
        subject.instance_variable_set :@options, options
      end

      it "should be delegated #according_to" do
        subject.according_to :foo
        expect(options).to have_received(:according_to).with(:foo)
      end

      it "should be delegated #checking" do
        subject.checking :foo
        expect(options).to have_received(:checking).with(:foo)
      end

      it "should be delegated #checking_only" do
        subject.checking_only :foo
        expect(options).to have_received(:checking_only).with(:foo)
      end

      it "should be delegated #skipping" do
        subject.skipping :foo
        expect(options).to have_received(:skipping).with(:foo)
      end

      it "should be delegated #with_options" do
        subject.with_options :foo
        expect(options).to have_received(:with_options).with(:foo)
      end
    end

    describe "chainable api" do
      its(:within) { is_expected.to be subject }
      its(:excluding) { is_expected.to be subject }
      its(:according_to) { is_expected.to be subject }
      its(:checking) { is_expected.to be subject }
      its(:checking_only) { is_expected.to be subject }
      its(:skipping) { is_expected.to be subject }
    end

    describe "#call" do
      let(:page) { spy("page", execute_async_script_fixed: { "violations" => [] }) }
      let(:results) { spy("results") }
      let(:audit) { spy("audit") }

      it "should execute the axe.run JS method" do
        subject.call(page)
        expect(page).to have_received(:execute_async_script_fixed).with(/axe.run/, anything, anything)
      end

      it "should return an audit" do
        expect(subject.call(page)).to be_kind_of Audit
      end

      it "should parse the results" do
        expect(Results).to receive(:new).with("violations" => []).and_return results
        expect(Audit).to receive(:new).with(instance_of(String), results)
        subject.call(page)
      end

      it "should include the original invocation string" do
        expect(Audit).to receive(:new).with(/axe.run/, instance_of(Results))
        subject.call(page)
      end
    end

    describe "#analyze_post_43x" do
      let(:timeouts) { Struct.new(:page_load).new(10) }
      let(:manage) { double("manage", timeouts: timeouts) }
      let(:selenium) { double("selenium", manage: manage) }
      let(:page) { double("page", assert_context_supported!: nil) }
      let(:configuration) { double("configuration", skip_iframes: nil) }
      let(:lib) { "{}" }

      before do
        allow(Axe::Configuration).to receive(:instance).and_return(configuration)
        allow(subject).to receive(:get_selenium).and_return(selenium)
        allow(subject).to receive(:window_handle).and_return("win-1")
        allow(subject).to receive(:within_about_blank_context).and_return({ "violations" => [] })
      end

      it "asks Cuprite-like pages to validate iframe contexts before running partials" do
        subject.within iframe: "#child", selector: "#bad"

        expect(page).to receive(:assert_context_supported!)
          .with({ "include" => [["#child", "#bad"]] }, configuration.skip_iframes)
          .ordered
        expect(subject).to receive(:run_partial_recursive).with(page, anything, lib, true).ordered.and_return([])

        subject.analyze_post_43x(page, lib)
      end
    end

    describe "#run_partial_recursive" do
      let(:context) { spy("context") }
      before :each do
        allow(subject).to receive(:get_frame_context_script).and_return({ "key" => "doesn't matter"})
        subject.instance_variable_set :@context, context
      end
      let(:lib) { "{}" }

      it "should throw errorMessage if top level axe.runPartial errors" do
        page = spy("page", execute_async_script_fixed: { "errorMessage" => "some error" }) 

        expect {
          subject.send :run_partial_recursive, page, context, lib, true
        }.to  raise_error /some error/
      end

      it "should throw an error if top level axe.runPartial returns null" do
        page = spy("page", execute_async_script_fixed: nil) 
        expect {
          subject.send :run_partial_recursive, page, context, lib, true
        }.to  raise_error /returned null/
      end

      it "should return array of nil if not top level and axe.runPartial errors" do
        page = spy("page", execute_async_script_fixed: nil) 
        expect(subject.send :run_partial_recursive, page, context, lib, false).to eq [nil]
      end

      it "should return array of nil if not top level and axe.runPartial returns nil" do
        page = spy("page", execute_async_script_fixed: { "errorMessage" => "some error" }) 
        expect(subject.send :run_partial_recursive, page, context, lib, false).to eq [nil]
      end

    end

    describe "#get_frame_context_script" do
      it "does not discover frame contexts when iframe auditing is skipped" do
        page = spy("page")
        configuration = double("configuration", skip_iframes: true)

        allow(Axe::Configuration).to receive(:instance).and_return(configuration)

        expect(subject.send(:get_frame_context_script, page)).to eq []
        expect(page).not_to have_received(:execute_script_fixed)
      end
    end
  end
end
