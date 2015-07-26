module Axe
  module Cucumber
    module Steps

      # base

      def accessible
        expect(Axe::Cucumber.page(self)).to be_accessible
      end

      def inaccessible
        expect(Axe::Cucumber.page(self)).to_not be_accessible
      end

      def accessible_within(inclusion)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion)
      end

      def inaccessible_within(inclusion)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion)
      end

      def accessible_excluding(exclusion)
        expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion)
      end

      def inaccessible_excluding(exclusion)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion)
      end

      def accessible_within_but_excluding(inclusion, exclusion)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion)
      end

      def inaccessible_within_but_excluding(inclusion, exclusion)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion)
      end


      # checking preset rules for given tag

      def accessible_according_to(tag)
        expect(Axe::Cucumber.page(self)).to be_accessible.for_tag(tag)
      end

      def inaccessible_according_to(tag)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.for_tag(tag)
      end

      def accessible_within_according_to(inclusion, tag)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).for_tag(tag)
      end

      def inaccessible_within_according_to(inclusion, tag)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).for_tag(tag)
      end

      def accessible_excluding_according_to(exclusion, tag)
        expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).for_tag(tag)
      end

      def inaccessible_excluding_according_to(exclusion, tag)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).for_tag(tag)
      end

      def accessible_within_but_excluding_according_to(inclusion, exclusion, tag)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
      end

      def inaccessible_within_but_excluding_according_to(inclusion, exclusion, tag)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
      end


      # checking given rules

      def accessible_checking(rule)
        expect(Axe::Cucumber.page(self)).to be_accessible.for_rule(rule)
      end

      def inaccessible_checking(rule)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.for_rule(rule)
      end

      def accessible_within_checking(inclusion, rule)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).for_rule(rule)
      end

      def inaccessible_within_checking(inclusion, rule)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).for_rule(rule)
      end

      def accessible_excluding_checking(exclusion, rule)
        expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).for_rule(rule)
      end

      def inaccessible_excluding_checking(exclusion, rule)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).for_rule(rule)
      end

      def accessible_within_but_excluding_checking(inclusion, exclusion, rule)
        expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
      end

      def inaccessible_within_but_excluding_checking(inclusion, exclusion, rule)
        expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
      end

      # with custom options

      def accessible_custom
      end

      def inaccessible_custom
      end

      def accessible_within_custom
      end

      def inaccessible_within_custom
      end

      def accessible_excluding_custom
      end

      def inaccessible_excluding_custom
      end

      def accessible_within_but_excluding_custom
      end

      def inaccessible_within_but_excluding_custom
      end

    end
  end
end
