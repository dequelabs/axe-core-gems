include CustomA11yMatchers

Then(/^the page should be accessible$/) do
  expect(page).to be_accessible
end

Then(/^the page should not be accessible$/) do
  expect(page).to_not be_accessible
end

Then(/^the page should be accessible within "(.*?)"$/) do |scope|
  expect(page).to be_accessible.within(scope)
end

Then(/^the page should not be accessible within "(.*?)"$/) do |scope|
  expect(page).to_not be_accessible.within(scope)
end

# Then(/^the page should be accessible for tag "(.*?)"$/) do |tag|
#   expect(page).to be_accessible_for_tag(tag)
# end
#
# Then(/^the page should not be accessible for tag "(.*?)"$/) do |tag|
#   expect(page).to_not be_accessible_for_tag(tag)
# end
#
# Then(/^the page should be accessible for rule "(.*?)"$/) do |rule|
#   expect(page).to be_accessible_for_rule(rule)
# end
#
# Then(/^the page should not be accessible for tag "(.*?)"$/) do |rule|
#   expect(page).to_not be_accessible_for_rule(rule)
# end
