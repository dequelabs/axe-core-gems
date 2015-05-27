include A11yMatchers

Then(/^the page should be accessible$/) do
  expect(page).to be_accessible
end

Then(/^the page should not be accessible$/) do
  expect(page).to_not be_accessible
end

Then(/^the page should be accessible within "(.*?)"$/) do |inclusion|
  expect(page).to be_accessible.within(inclusion)
end

Then(/^the page should not be accessible within "(.*?)"$/) do |inclusion|
  expect(page).to_not be_accessible.within(inclusion)
end

Then(/^the page should be accessible excluding "(.*?)"$/) do |exclusion|
  expect(page).to be_accessible.excluding(exclusion)
end

Then(/^the page should not be accessible excluding "(.*?)"$/) do |exclusion|
  expect(page).to_not be_accessible.excluding(exclusion)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)"$/) do |inclusion, exclusion|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)"$/) do |inclusion, exclusion|
  expect(page).to_not be_accessible.within(inclusion).excluding(exclusion)
end

Then(/^the page should be accessible for tags? "(.*?)"$/) do |tag|
  expect(page).to be_accessible.for_tag(tag)
end

Then(/^the page should not be accessible for tags? "(.*?)"$/) do |tag|
  expect(page).to_not be_accessible.for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" for tags? "(.*?)"$/) do |inclusion, tag|
  expect(page).to be_accessible.within(inclusion).for_tag(tag)
end

Then(/^the page should not be accessible within "(.*?)" for tags? "(.*?)"$/) do |inclusion, tag|
  expect(page).to_not be_accessible.within(inclusion).for_tag(tag)
end

Then(/^the page should be accessible excluding "(.*?)" for tags? "(.*?)"$/) do |exclusion, tag|
  expect(page).to be_accessible.excluding(exclusion).for_tag(tag)
end

Then(/^the page should not be accessible excluding "(.*?)" for tags? "(.*?)"$/) do |exclusion, tag|
  expect(page).to_not be_accessible.excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for tags? "(.*?)"$/) do |inclusion, exclusion, tag|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" for tags? "(.*?)"$/) do |inclusion, exclusion, tag|
  expect(page).to_not be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible for rules? "(.*?)"$/) do |rule|
  expect(page).to be_accessible.for_rule(rule)
end

Then(/^the page should not be accessible for rules? "(.*?)"$/) do |rule|
  expect(page).to_not be_accessible.for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" for rules? "(.*?)"$/) do |inclusion, rule|
  expect(page).to be_accessible.within(inclusion).for_rule(rule)
end

Then(/^the page should not be accessible within "(.*?)" for rules? "(.*?)"$/) do |inclusion, rule|
  expect(page).to_not be_accessible.within(inclusion).for_rule(rule)
end

Then(/^the page should be accessible excluding "(.*?)" for rules? "(.*?)"$/) do |exclusion, rule|
  expect(page).to be_accessible.excluding(exclusion).for_rule(rule)
end

Then(/^the page should not be accessible excluding "(.*?)" for rules? "(.*?)"$/) do |exclusion, rule|
  expect(page).to_not be_accessible.excluding(exclusion).for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for rules? "(.*?)"$/) do |inclusion, exclusion, rule|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" for rules? "(.*?)"$/) do |inclusion, exclusion, rule|
  expect(page).to_not be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
end

Then(/^the page should be accessible with options "(.*?)"$/) do |options|
  expect(page).to be_accessible.with_options(options)
end

Then(/^the page should not be accessible with options "(.*?)"$/) do |options|
  expect(page).to_not be_accessible.with_options(options)
end

Then(/^the page should be accessible within "(.*?)" with options "(.*?)"$/) do |inclusion, options|
  expect(page).to be_accessible.within(inclusion).with_options(options)
end

Then(/^the page should not be accessible within "(.*?)" with options "(.*?)"$/) do |inclusion, options|
  expect(page).to_not be_accessible.within(inclusion).with_options(options)
end

Then(/^the page should be accessible excluding "(.*?)" with options "(.*?)"$/) do |exclusion, options|
  expect(page).to be_accessible.excluding(exclusion).with_options(options)
end

Then(/^the page should not be accessible excluding "(.*?)" with options "(.*?)"$/) do |exclusion, options|
  expect(page).to_not be_accessible.excluding(exclusion).with_options(options)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" with options "(.*?)"$/) do |inclusion, exclusion, options|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).with_options(options)
end

Then(/^the page should not be accessible within "(.*?)" excluding "(.*?)" with options "(.*?)"$/) do |inclusion, exclusion, options|
  expect(page).to_not be_accessible.within(inclusion).excluding(exclusion).with_options(options)
end
