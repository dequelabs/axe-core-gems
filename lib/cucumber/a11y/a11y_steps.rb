Then(/^the page should be accessible$/) do
  expect(page).to be_accessible
end

Then(/^the page should not be accessible$/) do
  expect(page).to_not be_accessible
end

Then(/^"(.*?)" should be accessible$/) do |scope|
  expect(page).to be_accessible_within(scope)
end

Then(/^"(.*?)" should not be accessible$/) do |scope|
  expect(page).to_not be_accessible_within(scope)
end
