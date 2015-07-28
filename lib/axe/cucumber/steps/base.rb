module Axe
  module Cucumber
    class Steps
      module Base
        def accessible_within(inclusion)
          assert accessibility.within(selector(inclusion))
        end

        def inaccessible_within(inclusion)
          refute accessibility.within(selector(inclusion))
        end

        def accessible_excluding(exclusion)
          assert accessibility.excluding(selector(exclusion))
        end

        def inaccessible_excluding(exclusion)
          refute accessibility.excluding(selector(exclusion))
        end

        def accessible_within_but_excluding(inclusion, exclusion)
          assert accessibility.within(selector(inclusion)).excluding(selector(exclusion))
        end

        def inaccessible_within_but_excluding(inclusion, exclusion)
          refute accessibility.within(selector(inclusion)).excluding(selector(exclusion))
        end
      end
    end
  end
end
