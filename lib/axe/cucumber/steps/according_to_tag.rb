module Axe
  module Cucumber
    class Steps
      module AccordingToTag
        def accessible_according_to(tag)
          assert accessibility.for_tag(tag)
        end

        def inaccessible_according_to(tag)
          refute accessibility.for_tag(tag)
        end

        def accessible_within_according_to(inclusion, tag)
          assert accessibility.within(inclusion).for_tag(tag)
        end

        def inaccessible_within_according_to(inclusion, tag)
          refute accessibility.within(inclusion).for_tag(tag)
        end

        def accessible_excluding_according_to(exclusion, tag)
          assert accessibility.excluding(exclusion).for_tag(tag)
        end

        def inaccessible_excluding_according_to(exclusion, tag)
          refute accessibility.excluding(exclusion).for_tag(tag)
        end

        def accessible_within_but_excluding_according_to(inclusion, exclusion, tag)
          assert accessibility.within(inclusion).excluding(exclusion).for_tag(tag)
        end

        def inaccessible_within_but_excluding_according_to(inclusion, exclusion, tag)
          refute accessibility.within(inclusion).excluding(exclusion).for_tag(tag)
        end
      end
    end
  end
end
