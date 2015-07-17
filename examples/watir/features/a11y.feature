Feature: Example using minimal Watir-Webdriver setup (using firefox)

  Background:
    Given I am a visitor
    When I visit "http://abcdcomputech.dequecloud.com/"

  # The steps for the following scenarios are provided by the rspec-axe gem

  Scenario: Test whole page (known to be inaccessible, should fail)
    Then the page should be accessible

  Scenario: Test working sub-tree (should pass)
    Then the page should be accessible within "#working"

  Scenario: Test broken sub-tree (known to be inaccessible)
    Then the page should not be accessible within "#broken"
