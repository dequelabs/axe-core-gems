require 'spec_helper'
require 'axe/api/a11y_check'

module Axe::API
  describe A11yCheck do

    describe "@context" do
      let(:context) { spy('context') }
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
      let(:options) { spy('options') }
      before :each do
        subject.instance_variable_set :@options, options
      end

      it "should be delegated #according_to" do
        subject.according_to :foo
        expect(options).to have_received(:according_to).with(:foo)
      end

      it "should be delegated #checking" do
        subject.checking :foo
        expect(options).to have_received(:checking).with( :foo)
      end

      it "should be delegated #checking_only" do
        subject.checking_only :foo
        expect(options).to have_received(:checking_only).with( :foo)
      end

      it "should be delegated #skipping" do
        subject.skipping :foo
        expect(options).to have_received(:skipping).with( :foo)
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
      let(:page) { spy('page', execute_async_script: {'violations' => []}) }
      let(:results) { spy('results') }
      let(:audit) { spy('audit') }

      it "should execute the axe.run JS method" do
        subject.call(page)
        expect(page).to have_received(:execute_async_script).with("axe.run.apply(axe, arguments)")
      end

      it "should return an audit" do
        expect(subject.call(page)).to be_kind_of Audit
      end

      it "should parse the results" do
        expect(Results).to receive(:new).with('violations' => []).and_return results
        expect(Audit).to receive(:new).with(instance_of(String), results)
        subject.call(page)
      end

      it "should include the original invocation string" do
        expect(Audit).to receive(:new).with("axe.run(callback);", instance_of(Results))
        subject.call(page)
      end
    end
  end
end
