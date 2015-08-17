#######
# this block would typically go in spec_helper
require 'capybara/rspec'
require 'axe/rspec'
#######

describe "ABCD CompuTech", :type => :feature, :driver => :selenium do
  before :each do
    visit 'http://abcdcomputech.dequecloud.com/'
  end

  it "is known to be inaccessible, should fail" do
    expect(page).to be_accessible
  end

  it "is known to have an accessible sub-tree (should pass)" do
    expect(page).to be_accessible.within '#working'
  end

  it "is known to have an inaccessible sub-tree (should fail)" do
    expect(page).to be_accessible.within '#broken'
  end
end
