module Axe
  module Cucumber
    module Steps
      module AccordingToTag
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
      end
    end
  end
end
