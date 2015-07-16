require 'spec_helper'
require 'axe/cucumber/configuration'

module Axe::Cucumber
  describe Configuration do

    it { is_expected.to respond_to :page }
    it { is_expected.to respond_to :page= }

    describe "#page_from" do
      let(:world) { double('world') }

      before :each do
        subject.page = page
        world.instance_variable_set :@browser, "dummy_driver"
      end

      context "when #page is string" do
        let(:page) { "@browser" }

        it "should eval from world" do
          expect(subject.page_from(world)).to eq "dummy_driver"
        end
      end

      context "when #page is symbol" do
        let(:page) { :@browser }

        it "should eval from world" do
          expect(subject.page_from(world)).to eq "dummy_driver"
        end
      end

      context "when #page is object" do
        let(:page) { double('browser') }

        it "should return #page" do
          expect(subject.page_from(world)).to be page
        end
      end

      context "when #page is not configured" do
        let(:page) { double('browser') }

        it "should default to world.page" do
          allow(world).to receive(:page).and_return(page)
          expect(subject.page_from(world)).to be page
        end
      end
    end

  end
end
