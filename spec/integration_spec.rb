require 'spec_helper'
require 'capybara/rspec'
require 'axe/matchers'

RSpec.configure do |c|
  c.include Axe::Matchers
end

Capybara.default_driver = :selenium_chrome_headless

feature "BeAccessible", :integration, :slow do
  background do
    visit 'https://dequelabs.github.io/axe-fixtures/shadow-dom.html'
  end

  given(:subject) { page }

  scenario "check known inaccessible page" do
    expect { expect(page).to_not be_accessible }.to_not raise_error
    expect { expect(page).to be_accessible }.to raise_error(/Found ([1-6]) accessibility violations/)
  end

  scenario "check known accessible subtree" do
    expect { expect(page).to be_accessible.within("#no_issues") }.to_not raise_error
    expect { expect(page).to_not be_accessible.within("#no_issues") }.to raise_error(/Expected to find accessibility violations. None were detected./)
  end

  scenario "exclude known inaccessible subtree" do
    expect { expect(page).to be_accessible.within("#list_probz").excluding("ul") }.to_not raise_error
    expect { expect(page).to_not be_accessible.within("#list_probz").excluding("ul") }.to raise_error(/Expected to find accessibility violations. None were detected./)
  end
end
