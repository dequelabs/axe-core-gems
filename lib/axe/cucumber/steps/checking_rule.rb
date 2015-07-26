module Axe
  module Cucumber
    module Steps
      module CheckingRule
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
      end
    end
  end
end
