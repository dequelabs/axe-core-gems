require 'axe/matchers/be_accessible'
require 'axe/cucumber/steps/base'
require 'axe/cucumber/steps/according_to_tag'
require 'axe/cucumber/steps/checking_rule'
require 'axe/cucumber/steps/with_options'

# this class is meant to contain all the step procs that will be registered
# in the step_definitions. The procs are mixed in via the Base, AccordingToTag,
# CheckingRule, and WithOptions modules. The purpose of this class is to
# enable private helper methods for assertion and cucumber argument parsing
# without leaking the helper methods into the cucumber World object.
# Further, using these helper methods for assert/refute removes the dependency
# on rspec. So end users may choose to use any (or non) assertion/expectation
# library, as this class uses the Axe Accessibility Matcher directly, without
# using a matcher/expectation library DSL.
module Axe
  module Cucumber
    class Steps
      include Base
      include AccordingToTag
      include CheckingRule
      include WithOptions

      def initialize(page)
        @page = page
      end

      private

      attr_reader :page

      def accessibility
        Matchers::BeAccessible.new
      end

      def selector(selector)
        selector.split(/,\s*/)
      end

      def assert(matcher)
        raise matcher.failure_message unless matcher.matches? page
      end

      def refute(matcher)
        raise matcher.failure_message_when_negated if matcher.matches? page
      end
    end
  end
end
