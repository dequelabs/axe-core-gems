Feature: aXe cucumber steps can be run against multiple webdrivers

  Scenario Outline: Test whole page
    Given I am using <webdriver> to drive <browser>

    When I visit "http://abcdcomputech.dequecloud.com/"

    Then the page should not be accessible
    # And the page should be accessible within "#working"
    # And the page should not be accessible within "#broken"

    Examples:
      | webdriver | browser |
      | capybara | webkit |
      | capybara | firefox |
      | watir | firefox |
