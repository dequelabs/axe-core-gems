module Axe
  module Cucumber
    class Steps
      module WithOptions
        def accessible_custom(options)
          assert accessibility.with_options(options)
        end

        def inaccessible_custom(options)
          refute accessibility.with_options(options)
        end

        def accessible_within_custom(inclusion, options)
          assert accessibility.within(inclusion).with_options(options)
        end

        def inaccessible_within_custom(inclusion, options)
          refute accessibility.within(inclusion).with_options(options)
        end

        def accessible_excluding_custom(exclusion, options)
          assert accessibility.excluding(exclusion).with_options(options)
        end

        def inaccessible_excluding_custom(exclusion, options)
          refute accessibility.excluding(exclusion).with_options(options)
        end

        def accessible_within_but_excluding_custom(inclusion, exclusion, options)
          assert accessibility.within(inclusion).excluding(exclusion).with_options(options)
        end

        def inaccessible_within_but_excluding_custom(inclusion, exclusion, options)
          refute accessibility.within(inclusion).excluding(exclusion).with_options(options)
        end
      end
    end
  end
end
