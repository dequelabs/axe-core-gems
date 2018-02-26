require 'spec_helper'
require 'capybara/rspec'
require 'capybara-webkit'
require 'axe/matchers'

RSpec.configure do |c|
  c.include Axe::Matchers
end

Capybara.default_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.allow_url("abcdcomputech.dequecloud.com")
end

feature "BeAccessible", :integration, :slow do
  background do
    visit 'http://abcdcomputech.dequecloud.com'
  end

  given(:subject) { page }

  scenario "check known inaccessible page" do
    expect { expect(page).to_not be_accessible }.to_not raise_error
    expect { expect(page).to be_accessible }.to raise_error(/Found ([4-6]) accessibility violations/)
  end

  scenario "check known accessible subtree" do
    expect { expect(page).to be_accessible.within("#intro") }.to_not raise_error
    expect { expect(page).to_not be_accessible.within("#intro") }.to raise_error(/Expected to find accessibility violations. None were detected./)
  end

  scenario "exclude known inaccessible subtree" do
    expect { expect(page).to be_accessible.within("#topbar").excluding(".fl_left") }.to_not raise_error
    expect { expect(page).to_not be_accessible.within("#topbar").excluding(".fl_left") }.to raise_error(/Expected to find accessibility violations. None were detected./)
  end
end
