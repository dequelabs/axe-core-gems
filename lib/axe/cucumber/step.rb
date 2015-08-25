require 'yaml'

require 'axe'
require 'axe/matchers/be_accessible'

# The purpose of this class is to enable private helper methods for assertion
# and cucumber argument parsing without leaking the helper methods into the
# cucumber World object.
# Further, using these helper methods for assert/refute removes the dependency
# on rspec. So end users may choose to use any (or non) assertion/expectation
# library, as this class uses the Axe Accessibility Matcher directly, without
# using a matcher/expectation library DSL.
module Axe
  module Cucumber
    class Step
      REGEX = /^

      # require initial phrasing, with 'not' to negate the matcher
      (?-x:the page should(?<negate> not)? be accessible)

      # optionally specify which subtree to check, via CSS selector
      (?-x:;? within "(?<inclusion>.*?)")?

      # optionally specify subtrees to be excluded, via CSS selector
      (?-x:;?(?: but)? excluding "(?<exclusion>.*?)")?

      # optionally specify ruleset via list of comma-separated tags
      (?-x:;? according to: (?<tags>.*?))?

      # optionally specify rules (as comma-separated list of rule ids) to check
      # in addition to default ruleset or explicit ruleset specified above via tags
      # if the 'only' keyword is supplied, then *only* the listed rules are checked, not *additionally*
      (?-x:;?(?: and)? checking(?<run_only> only)?: (?<run_rules>.*?))?

      # optionally specify rules (as comma-separated list of rule ids) to skip
      (?-x:;?(?: but)? skipping: (?<skip_rules>.*?))?

      # optionally specify custom options (as a yaml-parsed hash or json string) to pass directly to axe-core
      (?-x:;? with options: (?<options>.*?))?

      $/x

      def self.create_for(world)
        new Axe.page_from world
      end

      def initialize(page)
        @page = page
      end

      def be_accessible(negate=false, inclusion="", exclusion="", tags="", run_only=false, run_rules="", skip_rules="", options="{}")
        accessibility = Matchers::BeAccessible.new

        accessibility.within(selector inclusion) if inclusion
        accessibility.excluding(selector exclusion) if exclusion
        accessibility.according_to(split tags) if tags
        run_only ? accessibility.checking_only(split run_rules) : accessibility.checking(split run_rules) if run_rules
        accessibility.skipping(split skip_rules) if skip_rules
        accessibility.with_options(to_hash options) if options

        if negate then refute accessibility else assert accessibility end
      end

      private

      attr_reader :page

      def selector(selector)
        split(selector)
      end

      def split(string)
        String(string).split(/,\s*/)
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
