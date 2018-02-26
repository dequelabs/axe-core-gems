Feature: iframes
  Background:
    Given I visit http://dylanb.github.io/uberframer.html

  Scenario: Audits iframes by default
    Then there should be 5 accessibility violations

  Scenario: IFrames can be skipped
    When I disable iframe auditing
    Then the page should be accessible according to: wcag2a; skipping: region, landmark-one-main
