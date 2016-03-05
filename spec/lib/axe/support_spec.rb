require 'spec_helper'
require 'axe/support'

module Axe
  describe Support do
    subject { described_class }

    describe "#page_from" do
      let(:world) { double('world') }

      context "when Axe.configuration#page is configured" do
        before :each do
          Axe.configuration.page = page
          world.instance_variable_set :@foo, :driver_double
        end

        context "as a string" do
          let(:page) { "@foo" }

          it "should eval from world" do
            expect(subject.page_from(world)).to eq :driver_double
          end
        end

        context "as a symbol" do
          let(:page) { :@foo }

          it "should eval from world" do
            expect(subject.page_from(world)).to eq :driver_double
          end
        end

        context "as an object" do
          let(:page) { double('browser') }

          it "should return #page" do
            expect(subject.page_from(world)).to be page
          end
        end
      end

      context "when Axe.configuration#page is not configured" do
        let(:world) { double('world') }

        before :each do
          # need to manually reset to default since configuration is a singleton
          # and the page double is leaking from the above context
          Axe.configuration.page = :page
        end

        it "should try world.page" do
          allow(world).to receive(:page).and_return(:page)
          expect(subject.page_from(world)).to be :page
        end

        it "should try world@page" do
          world.instance_variable_set :@page, :page
          expect(subject.page_from(world)).to eq :page
        end

        it "should try world@browser" do
          world.instance_variable_set :@browser, :browser
          expect(subject.page_from(world)).to eq :browser
        end

        it "should try world@driver" do
          world.instance_variable_set :@driver, :driver
          expect(subject.page_from(world)).to eq :driver
        end

        it "should try world@webdriver" do
          world.instance_variable_set :@webdriver, :webdriver
          expect(subject.page_from(world)).to eq :webdriver
        end

        it "should finally fall back to NullObject" do
          expect(subject.page_from(world)).to be_kind_of NullWebDriver
        end
      end
    end
  end
end
