Feature: aXe built-in cucumber steps

  Scenario: smoke test
    Given I visit http://abcdcomputech.dequecloud.com

    Then the page should not be accessible
    And the page should be accessible within "#top_bar"
    And the page should not be accessible within "#header"
    And the page should be accessible within "#header" according to: wcag2a, section508, best-practice
    And the page should not be accessible within "#header" checking: color-contrast
