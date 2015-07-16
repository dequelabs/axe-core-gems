@javascript
Feature: Example using default Capybara setup
  Default driver is :rack_test, uses :selenium by default for any test tagged
  with @javascript.

  Background:
    Given I am a visitor
    When I visit "http://abcdcomputech.dequecloud.com/"

  Scenario: Test whole page (should fail)
    # Then the page should not be accessible

  Scenario: Test working sub-tree (should pass)
    # Then the page should be accessible within "#working"

  Scenario: Test broken sub-tree (should fail)
    # Then the page should not be accessible within "#broken"
