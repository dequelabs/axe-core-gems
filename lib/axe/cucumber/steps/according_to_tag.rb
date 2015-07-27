module Axe
  module Cucumber
    class Steps
      module AccordingToTag
        def accessible_according_to(tag)
          assert accessibility.for_tags(split(tag))
        end

        def inaccessible_according_to(tag)
          refute accessibility.for_tags(split(tag))
        end

        def accessible_within_according_to(inclusion, tag)
          assert accessibility.within(selector(inclusion)).for_tags(split(tag))
        end

        def inaccessible_within_according_to(inclusion, tag)
          refute accessibility.within(selector(inclusion)).for_tags(split(tag))
        end

        def accessible_excluding_according_to(exclusion, tag)
          assert accessibility.excluding(selector(exclusion)).for_tags(split(tag))
        end

        def inaccessible_excluding_according_to(exclusion, tag)
          refute accessibility.excluding(selector(exclusion)).for_tags(split(tag))
        end

        def accessible_within_but_excluding_according_to(inclusion, exclusion, tag)
          assert accessibility.within(selector(inclusion)).excluding(selector(exclusion)).for_tags(split(tag))
        end

        def inaccessible_within_but_excluding_according_to(inclusion, exclusion, tag)
          refute accessibility.within(selector(inclusion)).excluding(selector(exclusion)).for_tags(split(tag))
        end
      end
    end
  end
end
