require 'yaml'

require 'axe/finds_page'
require 'axe/matchers'
require 'axe/expectation'

# The purpose of this class is to support private helpers for argument parsing
# without leaking the helper methods into the cucumber World object.
# Further, using these helper methods for assert/refute removes the dependency
# on rspec. So end users may choose to use any (or non) assertion/expectation
# library, as this class uses the Axe Accessibility Matcher directly, without
# using a matcher/expectation library DSL.
module Axe
  module Cucumber
    class Step
      REGEX = /^

      # require initial phrasing, with 'not' to negate the matcher
      (?-x:the page should( not)? be accessible)

      # optionally specify which subtree to check, via CSS selector
      (?-x:;? within "(.*?)")?

      # optionally specify subtrees to be excluded, via CSS selector
      (?-x:;?(?: but)? excluding "(.*?)")?

      # optionally specify ruleset via list of comma-separated tags
      (?-x:;? according to: (.*?))?

      # optionally specify rules to check as comma-separated list of rule ids
      # in addition to default ruleset or explicit ruleset specified above via tags
      # if the 'only' keyword is supplied, then *only* the listed rules are checked, not *additionally*
      (?-x:;?(?: and)? checking( only)?: (.*?))?

      # optionally specify rules to skip as comma-separated list of rule ids
      (?-x:;?(?: but)? skipping: (.*?))?

      # optionally specify custom options to pass directly to axe-core as a yaml-parsed hash or json string
      (?-x:;? with options: (.*?))?

      $/x

      def self.create_for(world)
        new(FindsPage.in(world).page)
      end

      def initialize(page)
        @page = page
      end

      def assert_accessibility(
        negate = false,
        inclusion = "",
        exclusion = "",
        tags = "",
        run_only = false,
        run_rules = "",
        skip_rules = "",
        options = nil
      )

        is_accessible = Axe::Matchers::BeAccessible.new.tap do |a|
          a.within(*selector(inclusion))
          a.excluding(*selector(exclusion))
          a.according_to(*split(tags))
          a.checking(*split(run_rules)) unless run_only
          a.checking_only(*split(run_rules)) if run_only
          a.skipping(*split(skip_rules))
          a.with_options to_hash(options)
        end

        Axe::AccessibilityExpectation.create(negate).assert @page, is_accessible
      end

      private

      def selector(selector)
        split(selector)
      end

      def split(string)
        String(string).split(/,\s*/)
      end

      def to_hash(string)
        (string && !string.empty?) ? YAML.load(String(string)) : {}
      end
    end
  end
end
