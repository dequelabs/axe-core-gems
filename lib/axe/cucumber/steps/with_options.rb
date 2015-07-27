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
          assert accessibility.within(selector(inclusion)).with_options(options)
        end

        def inaccessible_within_custom(inclusion, options)
          refute accessibility.within(selector(inclusion)).with_options(options)
        end

        def accessible_excluding_custom(exclusion, options)
          assert accessibility.excluding(selector(exclusion)).with_options(options)
        end

        def inaccessible_excluding_custom(exclusion, options)
          refute accessibility.excluding(selector(exclusion)).with_options(options)
        end

        def accessible_within_but_excluding_custom(inclusion, exclusion, options)
          assert accessibility.within(selector(inclusion)).excluding(selector(exclusion)).with_options(options)
        end

        def inaccessible_within_but_excluding_custom(inclusion, exclusion, options)
          refute accessibility.within(selector(inclusion)).excluding(selector(exclusion)).with_options(options)
        end
      end
    end
  end
end
