require 'spec_helper'
require 'axe/api/a11y_check'

module Axe::API
  describe A11yCheck do

    describe "@context" do
      let(:context) { spy('context') }
      before :each do
        subject.instance_variable_set :@context, context
      end

      it "should be delegated :include" do
        subject.include "foo"
        expect(context).to have_received(:include).with("foo")
      end

      it "should be delegated :exclude" do
        subject.exclude "foo"
        expect(context).to have_received(:exclude).with("foo")
      end
    end

    describe "@options" do
      let(:options) { spy('options') }
      before :each do
        subject.instance_variable_set :@options, options
      end

      it "should be delegated :rules_by_tags" do
        subject.rules_by_tags "foo"
        expect(options).to have_received(:rules_by_tags).with("foo")
      end

      it "should be delegated :run_only_rules" do
        subject.run_only_rules "foo"
        expect(options).to have_received(:run_only_rules).with("foo")
      end
    end

    describe "#to_js" do
      its(:to_js) { is_expected.to start_with "axe.a11yCheck(" }
      its(:to_js) { is_expected.to end_with ", function(results){axe.asyncResult = results;});" }

      it "should serialize context as first param" do
        context = double('context')
        allow(context).to receive(:to_json).and_return("{foo}")
        subject.instance_variable_set :@context, context

        expect(subject.to_js).to include '({foo},'
      end

      it "should serialize options as second param" do
        options = double('options')
        allow(options).to receive(:to_json).and_return("{bar}")
        subject.instance_variable_set :@options, options

        expect(subject.to_js).to include ', {bar},'
      end
    end
  end
end
