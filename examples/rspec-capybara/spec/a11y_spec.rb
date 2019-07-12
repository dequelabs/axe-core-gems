#######
# this block would typically go in spec_helper
require 'capybara/rspec'
require 'axe/rspec'
#######

# Typical example using standard RSpec dsl
describe "ABCD CompuTech (RSpec DSL)", :type => :feature, :driver => :selenium do
  before :each do
    visit 'http://abcdcomputech.dequecloud.com/'
  end

  it "is known to be inaccessible, should fail" do
    expect(page).not_to be_accessible
  end

  it "is known to have an accessible sub-tree (should pass)" do
    expect(page).to be_accessible.within '#intro'
  end

  it "is known to have an inaccessible sub-tree (should fail)" do
    expect(page).not_to be_accessible.within '#topbar'
  end
end

# Typical example using Capybara's DSL
feature "ABCD CompuTech (Capybara DSL)", :driver => :selenium do
  background do
    visit 'http://abcdcomputech.dequecloud.com/'
  end

  scenario "is known to be inaccessible, should fail" do
    expect(page).not_to be_accessible
  end

  scenario "is known to have an accessible sub-tree (should pass)" do
    expect(page).to be_accessible.within '#intro'
  end

  scenario "is known to have an inaccessible sub-tree (should fail)" do
    expect(page).not_to be_accessible.within '#topbar'
  end
end
