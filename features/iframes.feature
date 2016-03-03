Feature: iframes

  Scenario: Audits iframes by default
    Given I visit "http://dylanb.github.io/uberframer.html"
    Then there should be 2 accessibility violations


  Scenario: IFrames can be skipped
    Given I visit "http://dylanb.github.io/uberframer.html"
    When I disable iframe auditing
    Then the page should be accessible
