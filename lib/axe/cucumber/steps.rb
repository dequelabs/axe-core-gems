require 'axe/cucumber'

Then "the page should be accessible", :accessible

Then "the page should not be accessible", :inaccessible

Then "the page should be accessible within $selector", :accessible_within

Then "the page should not be accessible within $selector", :inaccessible_within

Then "the page should be accessible excluding $selector", :accessible_excluding

Then "the page should not be accessible excluding $selector", :inaccessible_excluding

Then "the page should be accessible within $selector excluding $selector", :accessible_within_but_excluding

Then "the page should not be accessible within $selector excluding $selector", :inaccessible_within_but_excluding

Then(/^the page should be accessible for tags? "(.*?)"$/) do |tag|
  expect(Axe::Cucumber.page(self)).to be_accessible.for_tag(tag)
end

Then(/^the page should not be accessible for tags? "(.*?)"$/) do |tag|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" for tags? "(.*?)"$/) do |inclusion, tag|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).for_tag(tag)
end

Then(/^the page should not be accessible within "(.*?)" for tags? "(.*?)"$/) do |inclusion, tag|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).for_tag(tag)
end

Then(/^the page should be accessible excluding "(.*?)" for tags? "(.*?)"$/) do |exclusion, tag|
  expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).for_tag(tag)
end

Then(/^the page should not be accessible excluding "(.*?)" for tags? "(.*?)"$/) do |exclusion, tag|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for tags? "(.*?)"$/) do |inclusion, exclusion, tag|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" for tags? "(.*?)"$/) do |inclusion, exclusion, tag|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible for rules? "(.*?)"$/) do |rule|
  expect(Axe::Cucumber.page(self)).to be_accessible.for_rule(rule)
end

Then(/^the page should not be accessible for rules? "(.*?)"$/) do |rule|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" for rules? "(.*?)"$/) do |inclusion, rule|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).for_rule(rule)
end

Then(/^the page should not be accessible within "(.*?)" for rules? "(.*?)"$/) do |inclusion, rule|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).for_rule(rule)
end

Then(/^the page should be accessible excluding "(.*?)" for rules? "(.*?)"$/) do |exclusion, rule|
  expect(Axe::Cucumber.page(self)).to be_accessible.excluding(exclusion).for_rule(rule)
end

Then(/^the page should not be accessible excluding "(.*?)" for rules? "(.*?)"$/) do |exclusion, rule|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.excluding(exclusion).for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for rules? "(.*?)"$/) do |inclusion, exclusion, rule|
  expect(Axe::Cucumber.page(self)).to be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" for rules? "(.*?)"$/) do |inclusion, exclusion, rule|
  expect(Axe::Cucumber.page(self)).to_not be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
end

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
