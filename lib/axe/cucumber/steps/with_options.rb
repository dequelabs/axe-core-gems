module Axe
  module Cucumber
    module Steps
      module WithOptions
        def accessible_custom(options)
          expect(Axe::Cucumber.page(self)).to be_accessible.with_options(options)
        end

        def inaccessible_custom(options)
          expect(Axe::Cucumber.page(self)).to_not be_accessible.with_options(options)
        end

        def accessible_within_custom(inclusion, options)
          expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).with_options(options)
        end

        def inaccessible_within_custom(inclusion, options)
          expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).with_options(options)
        end

        def accessible_excluding_custom(exclusion, options)
          expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).with_options(options)
        end

        def inaccessible_excluding_custom(exclusion, options)
          expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).with_options(options)
        end

        def accessible_within_but_excluding_custom(inclusion, exclusion, options)
          expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).with_options(options)
        end

        def inaccessible_within_but_excluding_custom(inclusion, exclusion, options)
          expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).with_options(options)
        end
      end
    end
  end
end
