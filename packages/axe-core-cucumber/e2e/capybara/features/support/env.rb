require "capybara/cucumber"
# require driver of choice
require "axe-capybara"
# Requiring 'axe-cucumber-steps' makes all of the axe-cucumber step
# definitions available to be used directly in your cucumber features.
require "axe-cucumber-steps"
# configure `AxeCapybara`
Before do
  # configure AxeWatir
  @driver = AxeCapybara.configure(:firefox) do |c|
  end
end

# close browser when done
After do
  @driver.page.browser.close
end
