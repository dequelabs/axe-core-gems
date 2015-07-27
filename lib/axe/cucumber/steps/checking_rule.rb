module Axe
  module Cucumber
    class Steps
      module CheckingRule
        def accessible_checking(rule)
          assert accessibility.for_rule(rule)
        end

        def inaccessible_checking(rule)
          refute accessibility.for_rule(rule)
        end

        def accessible_within_checking(inclusion, rule)
          assert accessibility.within(selector(inclusion)).for_rule(rule)
        end

        def inaccessible_within_checking(inclusion, rule)
          refute accessibility.within(selector(inclusion)).for_rule(rule)
        end

        def accessible_excluding_checking(exclusion, rule)
          assert accessibility.excluding(selector(exclusion)).for_rule(rule)
        end

        def inaccessible_excluding_checking(exclusion, rule)
          refute accessibility.excluding(selector(exclusion)).for_rule(rule)
        end

        def accessible_within_but_excluding_checking(inclusion, exclusion, rule)
          assert accessibility.within(selector(inclusion)).excluding(selector(exclusion)).for_rule(rule)
        end

        def inaccessible_within_but_excluding_checking(inclusion, exclusion, rule)
          refute accessibility.within(selector(inclusion)).excluding(selector(exclusion)).for_rule(rule)
        end
      end
    end
  end
end
