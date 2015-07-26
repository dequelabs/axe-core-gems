require 'axe/cucumber/configuration'
require 'axe/cucumber/steps'
require 'axe/cucumber/step_definitions'

# this module is exposed to Cucumber World to expose #axe_steps
# which returns an object that has all the axe_steps available on it

module Axe
  module Cucumber
    module BadWolf

      def axe_steps
        Steps.new Axe::Cucumber.page(self)
      end

    end
  end
end

# register module of step procs for step definitions
World(Axe::Cucumber::BadWolf)
