require 'timeout'
require 'axe/matchers/be_accessible'

module Axe::Matchers
  describe BeAccessible do
    let(:a11y_check) { spy('a11y_check', call: audit) }
    let(:audit) { spy('audit') }
    before :each do
      subject.instance_variable_set :@a11y_check, a11y_check
    end

    describe "#matches?" do
      let(:page) { spy('page') }

      it "should run the a11y_check against the page" do
        expect(Axe::Page).to receive(:new).with(page).and_return("page")
        subject.matches?(page)
        expect(a11y_check).to have_received(:call).with("page")
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
        subject.within(:foo)
        expect(a11y_check).to have_received(:include).with(:foo)
      end

      it "should return self for chaining" do
        expect(subject.within(:foo)).to be subject
      end
    end

    describe "#excluding" do
      it "should be delegated to @a11y_check" do
        subject.excluding(:foo)
        expect(a11y_check).to have_received(:exclude).with(:foo)
      end

      it "should return self for chaining" do
        expect(subject.excluding(:foo)).to be subject
      end
    end

    describe "#according_to" do
      it "should be delegated to @a11y_check" do
        subject.according_to(:foo)
        expect(a11y_check).to have_received(:rules_by_tags)
      end

      it "should accept a single tag" do
        subject.according_to(:foo)
        expect(a11y_check).to have_received(:rules_by_tags).with([:foo])
      end

      it "should accept many tags" do
        subject.according_to(:foo, :bar)
        expect(a11y_check).to have_received(:rules_by_tags).with([:foo, :bar])
      end

      it "should accept an array of tags" do
        subject.according_to([:foo, :bar])
        expect(a11y_check).to have_received(:rules_by_tags).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.according_to(:foo)).to be subject
      end
    end

    describe "#checking" do
      it "should be delegated to @a11y_check" do
        subject.checking(:foo)
        expect(a11y_check).to have_received(:run_rules)
      end

      it "should accept a single rule" do
        subject.checking(:foo)
        expect(a11y_check).to have_received(:run_rules).with([:foo])
      end

      it "should accept many rules" do
        subject.checking(:foo, :bar)
        expect(a11y_check).to have_received(:run_rules).with([:foo, :bar])
      end

      it "should accept an array of rules" do
        subject.checking([:foo, :bar])
        expect(a11y_check).to have_received(:run_rules).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.checking(:foo)).to be subject
      end
    end

    describe "#skipping" do
      it "should be delegated to @a11y_check" do
        subject.skipping(:foo)
        expect(a11y_check).to have_received(:skip_rules)
      end

      it "should accept a single rule" do
        subject.skipping(:foo)
        expect(a11y_check).to have_received(:skip_rules).with([:foo])
      end

      it "should accept many rules" do
        subject.skipping(:foo, :bar)
        expect(a11y_check).to have_received(:skip_rules).with([:foo, :bar])
      end

      it "should accept an array of rules" do
        subject.skipping([:foo, :bar])
        expect(a11y_check).to have_received(:skip_rules).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.skipping(:foo)).to be subject
      end
    end

    describe "#checking_only" do
      it "should be delegated to @a11y_check" do
        subject.checking_only(:foo)
        expect(a11y_check).to have_received(:run_only_rules)
      end

      it "should accept a single rule" do
        subject.checking_only(:foo)
        expect(a11y_check).to have_received(:run_only_rules).with([:foo])
      end

      it "should accept many rules" do
        subject.checking_only(:foo, :bar)
        expect(a11y_check).to have_received(:run_only_rules).with([:foo, :bar])
      end

      it "should accept an array of rules" do
        subject.checking_only([:foo, :bar])
        expect(a11y_check).to have_received(:run_only_rules).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.checking_only(:foo)).to be subject
      end
    end

    describe "#with_options" do
      it "should be delegated to @a11y_check" do
        subject.with_options(:foo)
        expect(a11y_check).to have_received(:custom_options)
      end

      it "should return self for chaining" do
        expect(subject.with_options(:foo)).to be subject
      end
    end

  end
end
