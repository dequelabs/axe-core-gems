require 'yaml'

require 'axe/matchers/be_accessible'
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
      include WithOptions

      def initialize(page)
        @page = page
      end

      def accessible(negate, inclusion, exclusion, tags, run_only, run_rules)
        a11y = Matchers::BeAccessible.new.tap do |a|
          a.within(selector inclusion) if inclusion
          a.excluding(selector exclusion) if exclusion
          a.according_to(split tags) if tags
          if run_rules
            if run_only
              a.checking_only(split run_rules)
            else
              #TODO add run_rules
            end
          end
        end


        if negate
          refute a11y
        else
          assert a11y
        end
      end

      private

      attr_reader :page

      def accessibility
        Matchers::BeAccessible.new
      end

      def selector(selector)
        split(selector)
      end

      def split(string)
        string.to_s.split(/,\s*/)
      end

      def to_hash(string)
        YAML.load string
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
