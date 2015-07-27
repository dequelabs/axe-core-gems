module Axe
  module Cucumber
    module Steps
      module Base
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
      end
    end
  end
end
