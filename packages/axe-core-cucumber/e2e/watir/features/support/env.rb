# load watir
require "watir"
# require driver of choice
require "axe-watir"
# Requiring 'axe-cucumber-steps' makes all of the axe-cucumber step
# definitions available to be used directly in your cucumber features.
require "axe-cucumber-steps"

Before do
  # configure AxeWatir
  @driver = AxeWatir.configure(:firefox) do |c|
  end
end

# close browser when done
After do
  @driver.page.close
end
