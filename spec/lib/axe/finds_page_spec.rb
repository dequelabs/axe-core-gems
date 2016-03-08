require 'spec_helper'
require 'axe/finds_page'

FakeWorld = Class.new { def page;end }

module Axe
  describe FindsPage do
    subject { described_class.in world }
    let(:world) { FakeWorld.new }

    describe "#page" do
      context "when Axe.configuration#page is configured" do
        before :each do
          Axe::Configuration.instance.page = page
          world.instance_variable_set :@foo, :driver_double
        end

        context "as a string" do
          let(:page) { "@foo" }

          it "should eval from world" do
            expect(subject.page).to eq :driver_double
          end
        end

        context "as a symbol" do
          let(:page) { :@foo }

          it "should eval from world" do
            expect(subject.page).to eq :driver_double
          end
        end

        context "as an object" do
          let(:page) { double('browser') }

          it "should return #page" do
            expect(subject.page).to be page
          end
        end
      end

      context "when Axe.configuration#page is not configured" do
        let(:world) { FakeWorld.new }

        before :each do
          # need to manually reset to default since configuration is a singleton
          # and the page double is leaking from the above context
          Axe::Configuration.instance.page = :page
        end

        it "should try world.page" do
          allow(world).to receive(:page).and_return(:page)
          expect(subject.page).to be :page
        end

        it "should try world@page" do
          world.instance_variable_set :@page, :page
          expect(subject.page).to eq :page
        end

        it "should try world@browser" do
          world.instance_variable_set :@browser, :browser
          expect(subject.page).to eq :browser
        end

        it "should try world@driver" do
          world.instance_variable_set :@driver, :driver
          expect(subject.page).to eq :driver
        end

        it "should try world@webdriver" do
          world.instance_variable_set :@webdriver, :webdriver
          expect(subject.page).to eq :webdriver
        end

        it "should finally fall back to NullObject" do
          expect(subject.page).to be_kind_of NullWebDriver
        end
      end
    end
  end
end
