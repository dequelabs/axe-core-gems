require 'spec_helper'
require 'axe/configuration'

module Axe
  describe Configuration do

    it { is_expected.to respond_to :page }
    it { is_expected.to respond_to :page= }

    describe "#page_from" do
      let(:world) { double('world') }

      before :each do
        subject.page = page
        world.instance_variable_set :@foo, :driver_double
      end

      context "when #page is string" do
        let(:page) { "@foo" }

        it "should eval from world" do
          expect(subject.page_from(world)).to eq :driver_double
        end
      end

      context "when #page is symbol" do
        let(:page) { :@foo }

        it "should eval from world" do
          expect(subject.page_from(world)).to eq :driver_double
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

        context "when world.page doesn't exist" do
          let(:page) { nil }

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
end
