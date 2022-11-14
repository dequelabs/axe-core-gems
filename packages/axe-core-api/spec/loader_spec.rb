require "spec_helper"
require_relative "../lib/loader"

module Common
  describe Loader do
    subject(:loader) { described_class.new(page, lib) }
    let(:page) { spy("page", evaluate_script: false) }
    let(:lib) { spy("lib") }

    describe "test" do
      it "should correctly fail ci" do
        expect(1).to eq 2
      end
    end

    describe "call" do
      it "should evaluate lib's source in the context of the given page" do
        loader.call(:source)
        expect(page).to have_received(:execute_script).with(:source)
      end

      it "should run the after_load hook" do
        expect(Common::Hooks).to receive(:run_after_load).with(lib)
        loader.call(:source)
      end

      context "when skipping iframes" do
        before do
          allow(Axe::Configuration.instance).to receive(:skip_iframes) { false }
        end
      end

      context "when not skipping iframes" do
        before do
          allow(Axe::Configuration.instance).to receive(:skip_iframes) { true }
        end

        it "should not find iframes" do
          loader.call(:source)
          expect(page).not_to have_received(:find_elements)
        end
      end
    end
  end
end
