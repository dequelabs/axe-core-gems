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
    end
  end
end
