require 'spec_helper'
require 'axe/javascript_library'

module Axe
  describe JavaScriptLibrary do

    its(:source) { should start_with "/*! aXe" }

    describe "inject_into" do
      it "should evaluate its source in the context of the given page" do
        page = spy('page')
        subject.inject_into(page)
        expect(page).to have_received(:execute_script).with(subject.source)
      end
    end

  end
end
