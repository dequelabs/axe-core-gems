require "spec_helper"

require_relative "../lib/axe-cucumber"

module CustomMatchers
  class Match < RSpec::Matchers::BuiltIn::Match
    def matches?(actual)
      # first ensure the regex matched
      return false unless result = super
      # only continue if specifying captures
      return result unless expected_captures = @captures

      actual_captures = to_hash result

      RSpec::Matchers::BuiltIn::Include.new(expected_captures).matches?(actual_captures).tap do |captures_matched|
        # replace expected/actual regex with the matchdata
        # if the matchdata didn't match. this way we get a diff of the matchdata hashes
        # otherwise, leave untouched so the description is per normal
        unless captures_matched
          @expected = expected_captures
          @actual = actual_captures
        end
      end
    end

    def capturing(captures)
      @captures = captures
      self
    end

    private

    def to_hash(matchdata)
      # Note: since not using named captures, have to use index look-up for converting matches to hash
      # Doc: https://ruby-doc.org/core-2.4.0/MatchData.html
      # Hash[matchdata.names.map(&:to_sym).zip matchdata.captures]
      {
        :negate => matchdata[1],
        :inclusion => matchdata[2],
        :exclusion => matchdata[3],
        :tags => matchdata[4],
        :run_only => matchdata[5],
        :run_rules => matchdata[6],
        :skip_rules => matchdata[7],
        :options => matchdata[8],
      }
    end
  end

  def matchy(expected)
    Match.new expected
  end
end

RSpec.configure { |c| c.include CustomMatchers }

module AxeCucumber
  describe Step do
    describe "::REGEX" do
      subject { described_class::REGEX }

      describe "negation" do
        it { is_expected.to matchy("the page should be accessible").capturing(negate: be_falsey) }
        it { is_expected.to matchy("the page should not be accessible").capturing(negate: be_truthy) }
      end

      describe "inclusion" do
        it {
          is_expected.to matchy('the page should be accessible within "foo"')
            .capturing(negate: be_falsey, inclusion: "foo")
        }
      end

      describe "exclusion" do
        it {
          is_expected.to matchy('the page should be accessible excluding "bar"')
            .capturing(negate: be_falsey, exclusion: "bar")
        }
      end

      describe "inclusion + exclusion" do
        it {
          is_expected.to matchy('the page should be accessible within "foo" excluding "bar"')
            .capturing(negate: be_falsey, inclusion: "foo", exclusion: "bar")
        }
        it {
          is_expected.to matchy('the page should be accessible within "foo" but excluding "bar"')
            .capturing(negate: be_falsey, inclusion: "foo", exclusion: "bar")
        }
      end

      describe "according to tags" do
        it {
          is_expected.to matchy("the page should be accessible according to: tag")
            .capturing(tags: "tag")
        }
        it {
          is_expected.to matchy("the page should be accessible according to: tag1, tag2")
            .capturing(tags: "tag1, tag2")
        }
      end

      describe "checking rules" do
        it {
          is_expected.to matchy("the page should be accessible checking: rule")
            .capturing(run_only: be_falsey, run_rules: "rule")
        }
        it {
          is_expected.to matchy("the page should be accessible checking: rule1, rule2")
            .capturing(run_only: be_falsey, run_rules: "rule1, rule2")
        }
      end

      describe "according to tags and checking extra rules" do
        it {
          is_expected.to matchy("the page should be accessible according to: tag checking: rule")
            .capturing(tags: "tag", run_rules: "rule", run_only: be_falsey)
        }
        it {
          is_expected.to matchy("the page should be accessible according to: tag and checking: rule")
            .capturing(tags: "tag", run_rules: "rule", run_only: be_falsey)
        }
        it {
          is_expected.to matchy("the page should be accessible according to: tag1, tag2 checking: rule1, rule2")
            .capturing(tags: "tag1, tag2", run_rules: "rule1, rule2", run_only: be_falsey)
        }
        it {
          is_expected.to matchy("the page should be accessible according to: tag1, tag2 and checking: rule1, rule2")
            .capturing(tags: "tag1, tag2", run_rules: "rule1, rule2", run_only: be_falsey)
        }
      end

      describe "checking only rules" do
        it {
          is_expected.to matchy("the page should be accessible checking only: rule")
            .capturing(run_only: be_truthy, run_rules: "rule")
        }
        it {
          is_expected.to matchy("the page should be accessible checking only: rule1, rule2")
            .capturing(run_only: be_truthy, run_rules: "rule1, rule2")
        }
      end

      describe "skipping rules" do
        it {
          is_expected.to matchy("the page should be accessible skipping: rule")
            .capturing(run_only: be_falsey, skip_rules: "rule")
        }
        it {
          is_expected.to matchy("the page should be accessible skipping: rule1, rule2")
            .capturing(run_only: be_falsey, skip_rules: "rule1, rule2")
        }
      end

      describe "checking rules and skipping others" do
        it {
          is_expected.to matchy("the page should be accessible checking: run skipping: skip")
            .capturing(run_rules: "run", skip_rules: "skip")
        }
        it {
          is_expected.to matchy("the page should be accessible checking: run but skipping: skip")
            .capturing(run_rules: "run", skip_rules: "skip")
        }
        it {
          is_expected.to matchy("the page should be accessible checking: run1, run2 skipping: skip1, skip2")
            .capturing(run_rules: "run1, run2", skip_rules: "skip1, skip2")
        }
        it {
          is_expected.to matchy("the page should be accessible checking: run1, run2 but skipping: skip1, skip2")
            .capturing(run_rules: "run1, run2", skip_rules: "skip1, skip2")
        }
      end

      describe "with options" do
        it { is_expected.to matchy("the page should be accessible with options: foo").capturing(options: "foo") }
        pending "with json syntax"
        pending "with hash syntax"
        pending "with quoted keys"
        pending "without quoted keys"
        pending "with braces"
        pending "without braces"
      end

      describe "everything" do
        # minimum
        it {
          is_expected.to matchy(
            'the page should be accessible
            within "foo"
            excluding "bar"
            according to: tag
            checking: run
            skipping: skip
            with options: qux'
          )
            .capturing(negate: be_falsey,
                       inclusion: "foo",
                       exclusion: "bar",
                       tags: "tag",
                       run_rules: "run",
                       skip_rules: "skip",
                       run_only: be_falsey,
                       options: "qux")
        }

        # using semicolons
        it {
          is_expected.to matchy(
            'the page should be accessible
            within "foo";
            excluding "bar";
            according to: tag;
            checking: run;
            skipping: skip;
            with options: qux'
          )
            .capturing(negate: be_falsey,
                       inclusion: "foo",
                       exclusion: "bar",
                       tags: "tag",
                       run_rules: "run",
                       skip_rules: "skip",
                       run_only: be_falsey,
                       options: "qux")
        }

        # using conjunctions
        it {
          is_expected.to matchy(
            'the page should be accessible
                            within "foo" but
                            excluding "bar"
                            according to: tag and
                            checking: run but
                            skipping: skip
                            with options: qux'
          )
            .capturing(negate: be_falsey,
                       inclusion: "foo",
                       exclusion: "bar",
                       tags: "tag",
                       run_rules: "run",
                       skip_rules: "skip",
                       run_only: be_falsey,
                       options: "qux")
        }
      end
    end
  end
end
