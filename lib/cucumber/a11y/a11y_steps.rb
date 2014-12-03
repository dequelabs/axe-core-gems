include CustomA11yMatchers

# Full page

Then(/^the page should be accessible$/) do
  expect(page).to be_accessible
end

# Within

Then(/^the page should be accessible within "(.*?)"$/) do |inclusion|
  expect(page).to be_accessible.within(inclusion)
end

# Excluding

Then(/^the page should be accessible excluding "(.*?)"$/) do |exclusion|
  expect(page).to be_accessible.excluding(exclusion)
end

# Include/Exclude

Then(/^the page should be accessible within "(.*?)" excluding "(.*?)"$/) do |inclusion, exclusion|
  expect(page).to be_accessible.within(inclusion).excluding(exclusion)
end

# Then(/^the page should be accessible for tag "(.*?)"$/) do |tag|
#   expect(page).to be_accessible_for_tag(tag)
# end
#
# Then(/^the page should be accessible for rule "(.*?)"$/) do |rule|
#   expect(page).to be_accessible_for_rule(rule)
# end
