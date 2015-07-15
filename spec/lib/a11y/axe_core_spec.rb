require 'spec_helper'
require 'rspec/a11y/axe_core'

module RSpec::A11y
  describe AxeCore do

    its(:source) { should start_with "/*! aXe" }

    describe "inject_into" do
      it "should evaluate its source in the context of the given page" do
        page = spy('page')
        subject.inject_into(page)
        expect(page).to have_received(:execute).with(subject.source)
      end
    end
  end
end
