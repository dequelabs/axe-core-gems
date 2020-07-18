require "spec_helper"

require_relative "../../lib/axe/finds_page"

FakeWorld = Class.new { def page; end }

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
          let(:page) { double("browser") }

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
          allow(world).to receive(:page).and_return(:from_page_method)
          expect(subject.page).to be :from_page_method
        end

        it "should try world@page" do
          world.instance_variable_set :@page, :from_page_ivar
          expect(subject.page).to eq :from_page_ivar
        end

        it "should try world@browser" do
          world.instance_variable_set :@browser, :from_browser_ivar
          expect(subject.page).to eq :from_browser_ivar
        end

        it "should try world@driver" do
          world.instance_variable_set :@driver, :from_driver_ivar
          expect(subject.page).to eq :from_driver_ivar
        end

        it "should try world@webdriver" do
          world.instance_variable_set :@webdriver, :from_webdriver_ivar
          expect(subject.page).to eq :from_webdriver_ivar
        end

        it "should finally raise an error" do
          expect { expect(subject.page) }.to raise_error(/webdriver/)
        end
      end
    end
  end
end
