module Axe
  module Cucumber
    class Steps
      module Base
        def accessible
          assert accessibility
        end

        def inaccessible
          refute accessibility
        end

        def accessible_within(inclusion)
          assert accessibility.within(inclusion)
        end

        def inaccessible_within(inclusion)
          refute accessibility.within(inclusion)
        end

        def accessible_excluding(exclusion)
          assert accessibility.excluding(exclusion)
        end

        def inaccessible_excluding(exclusion)
          refute accessibility.excluding(exclusion)
        end

        def accessible_within_but_excluding(inclusion, exclusion)
          assert accessibility.within(inclusion).excluding(exclusion)
        end

        def inaccessible_within_but_excluding(inclusion, exclusion)
          refute accessibility.within(inclusion).excluding(exclusion)
        end
      end
    end
  end
end
