require 'spec_helper'
require 'axe/loader'

module Axe
  describe Loader do
    subject(:loader) { described_class.new(page, lib) }
    let(:page) { spy('page') }
    let(:lib) { spy('lib', source: 'libsource') }

    describe "call" do
      it "should evaluate lib's source in the context of the given page" do
        loader.call
        expect(page).to have_received(:execute_script).with('libsource')
      end

      it "should run the after_load hook" do
        expect(Axe.configuration).to receive(:run_after_load_hook).with(lib)
        loader.call
      end
    end
  end
end
