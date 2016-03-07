require 'spec_helper'
require 'axe/loader'

module Axe
  describe Loader do
    subject(:loader) { described_class.new(page, lib) }
    let(:page) { spy('page', evaluate_script: false) }
    let(:lib) { spy('lib') }

    describe "call" do
      it "should evaluate lib's source in the context of the given page" do
        loader.call(:source)
        expect(page).to have_received(:execute_script).with(:source)
      end

      it "should run the after_load hook" do
        expect(Axe::Hooks).to receive(:run_after_load).with(lib)
        loader.call(:source)
      end
    end
  end
end
