include CustomA11yMatchers

Then(/^the page should be accessible$/) do
  expect(page).to be_accessible
end

Then(/^the page should be accessible within "(.*?)"$/) do |inclusion|
  expect(page).to be_accessible.within(inclusion)
end

Then(/^the page should be accessible excluding "(.*?)"$/) do |exclusion|
  expect(page).to be_accessible.excluding(exclusion)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)"$/) do |inclusion, exclusion|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion)
end

Then(/^the page should be accessible for tag "(.*?)"$/) do |tag|
  expect(page).to be_accessible.for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" for tag "(.*?)"$/) do |inclusion, tag|
  expect(page).to be_accessible.within(inclusion).for_tag(tag)
end

Then(/^the page should be accessible excluding "(.*?)" for tag "(.*?)"$/) do |exclusion, tag|
  expect(page).to be_accessible.excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for tag "(.*?)"$/) do |inclusion, exclusion, tag|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).for_tag(tag)
end

Then(/^the page should be accessible for rule(s?) "(.*?)"$/) do |rule|
  expect(page).to be_accessible.for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" for rule(s?) "(.*?)"$/) do |inclusion, rule|
  expect(page).to be_accessible.within(inclusion).for_rule(rule)
end

Then(/^the page should be accessible excluding "(.*?)" for rule(s?) "(.*?)"$/) do |exclusion, rule|
  expect(page).to be_accessible.excluding(exclusion).for_rule(rule)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" for rule(s?) "(.*?)"$/) do |inclusion, exclusion, rule|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).for_rule(rule)
end

Then(/^the page should be accessible with options "(.*?)"$/) do |options|
  expect(page).to be_accessible.with_options(options)
end

Then(/^the page should be accessible within "(.*?)" with options "(.*?)"$/) do |inclusion, options|
  expect(page).to be_accessible.within(inclusion).with_options(options)
end

Then(/^the page should be accessible excluding "(.*?)" with options "(.*?)"$/) do |exclusion, options|
  expect(page).to be_accessible.excluding(exclusion).with_options(options)
end

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)" with options "(.*?)"$/) do |inclusion, exclusion, options|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion).with_options(options)
end
