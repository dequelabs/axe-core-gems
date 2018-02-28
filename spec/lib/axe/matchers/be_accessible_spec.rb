require 'timeout'
require 'axe/matchers/be_accessible'

module Axe::Matchers
  describe BeAccessible do
    let(:a11y_check) { spy('a11y_check', call: audit) }
    let(:audit) { spy('audit') }
    let(:page) { spy('page') }
    let(:core) { spy('core') }
    before :each do
      subject.instance_variable_set :@a11y_check, a11y_check
    end

    describe "#matches?" do
      it "should run the a11y_check against the page" do
        expect(Axe::Core).to receive(:new).with(page).and_return(core)

        subject.matches?(page)

        expect(core).to have_received(:call).with(a11y_check)
      end

      it "should save results" do
        subject.matches? page
        expect( subject.instance_variable_get :@audit ).to be audit
      end

      it "should return results.passed" do
        allow(audit).to receive(:passed?).and_return(:passed)
        expect( subject.matches?(page) ).to be :passed
      end
    end

    describe "#audit" do
      it "should audit the page with an a11y check" do
        expect(Axe::Core).to receive(:new).with(page).and_return(core)
        expect(core).to receive(:call).with(a11y_check).and_return(audit)

        expect( subject.audit(page) ).to be audit
      end
    end

    describe "@audit" do
      before :each do
        subject.instance_variable_set :@audit, audit
      end

      it "should be delegated #failure_message" do
        expect(audit).to receive(:failure_message).and_return(:foo)
        expect(subject.failure_message).to eq :foo
      end

      it "should be delegated #failure_message_when_negated" do
        expect(audit).to receive(:failure_message_when_negated).and_return(:foo)
        expect(subject.failure_message_when_negated).to eq :foo
      end
    end

    describe "#within" do
      it "should be delegated to @a11y_check" do
        subject.within(:foo, :bar)
        expect(a11y_check).to have_received(:within).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.within).to be subject
      end
    end

    describe "#excluding" do
      it "should be delegated to @a11y_check" do
        subject.excluding(:foo, :bar)
        expect(a11y_check).to have_received(:excluding).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.excluding).to be subject
      end
    end

    describe "#according_to" do
      it "should be delegated to @a11y_check" do
        subject.according_to(:foo, :bar)
        expect(a11y_check).to have_received(:according_to).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.according_to).to be subject
      end
    end

    describe "#checking" do
      it "should be delegated to @a11y_check" do
        subject.checking(:foo, :bar)
        expect(a11y_check).to have_received(:checking).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.checking).to be subject
      end
    end

    describe "#skipping" do
      it "should be delegated to @a11y_check" do
        subject.skipping(:foo, :bar)
        expect(a11y_check).to have_received(:skipping).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.skipping).to be subject
      end
    end

    describe "#checking_only" do
      it "should be delegated to @a11y_check" do
        subject.checking_only(:foo, :bar)
        expect(a11y_check).to have_received(:checking_only).with(:foo, :bar)
      end

      it "should return self for chaining" do
        expect(subject.checking_only).to be subject
      end
    end

    describe "#with_options" do
      it "should be delegated to @a11y_check" do
        subject.with_options(:foo)
        expect(a11y_check).to have_received(:with_options).with(:foo)
      end

      it "should return self for chaining" do
        expect(subject.with_options(:foo)).to be subject
      end
    end

  end
end
