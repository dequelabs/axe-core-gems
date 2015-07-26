require 'axe/cucumber'

Then "the page should be accessible", :accessible

Then "the page should not be accessible", :inaccessible

Then "the page should be accessible within $selector", :accessible_within

Then "the page should not be accessible within $selector", :inaccessible_within

Then "the page should be accessible excluding $selector", :accessible_excluding

Then "the page should not be accessible excluding $selector", :inaccessible_excluding

Then "the page should be accessible within $selector but excluding $selector", :accessible_within_but_excluding

Then "the page should not be accessible within $selector but excluding $selector", :inaccessible_within_but_excluding



Then "the page should be accessible according to $tag", :accessible_according_to

Then "the page should not be accessible according to $tag", :inaccessible_according_to

Then "the page should be accessible within $selector according to $tag", :accessible_within_according_to

Then "the page should not be accessible within $selector according to $tag", :inaccessible_within_according_to

Then "the page should be accessible excluding $selector according to $tag", :accessible_excluding_according_to

Then "the page should not be accessible excluding $selector according to $tag", :inaccessible_excluding_according_to

Then "the page should be accessible within $selector but excluding $selector according to $tag", :accessible_within_but_excluding_according_to

Then "the page should not be accessible within $selector but excluding $selector according to $tag", :inaccessible_within_but_excluding_according_to



Then "the page should be accessible checking $rule", :accessible_checking

Then "the page should not be accessible checking $rule", :inaccessible_checking

Then "the page should be accessible within $selector checking $rule", :accessible_within_checking

Then "the page should not be accessible within $selector checking $rule", :inaccessible_within_checking

Then "the page should be accessible excluding $selector checking $rule", :accessible_excluding_checking

Then "the page should not be accessible excluding $selector checking $rule", :inaccessible_excluding_checking

Then "the page should be accessible within $selector but excluding $selector checking $rule", :accessible_within_but_excluding_checking

Then "the page should not be accessible within $selector but excluding $selector checking $rule", :inaccessible_within_but_excluding_checking



Then(/^the page should be accessible with options "(.*?)"$/) do |options|
  expect(Axe::Cucumber.page(self)).to be_accessible.with_options(options)
end

Then(/^the page should not be accessible with options "(.*?)"$/) do |options|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.with_options(options)
end

Then(/^the page should be accessible within "(.*?)" with options "(.*?)"$/) do |inclusion, options|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).with_options(options)
end

Then(/^the page should not be accessible within "(.*?)" with options "(.*?)"$/) do |inclusion, options|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).with_options(options)
end

Then(/^the page should be accessible excluding "(.*?)" with options "(.*?)"$/) do |exclusion, options|
  expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).with_options(options)
end

Then(/^the page should not be accessible excluding "(.*?)" with options "(.*?)"$/) do |exclusion, options|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).with_options(options)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" with options "(.*?)"$/) do |inclusion, exclusion, options|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).with_options(options)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" with options "(.*?)"$/) do |inclusion, exclusion, options|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).with_options(options)
end
