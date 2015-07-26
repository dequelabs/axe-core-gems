require 'axe/cucumber'
require 'axe/cucumber/steps'

# this module is included in Cucumber World to expose #axe_steps
# which returns an object that has all the axe_steps available on it
module Axe
  module Cucumber
    module World

      def axe_steps
        Steps.new Axe::Cucumber.page(self)
      end

    end
  end
end
