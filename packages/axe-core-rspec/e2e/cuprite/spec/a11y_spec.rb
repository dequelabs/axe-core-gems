require "spec_helper"

describe "axe under Cuprite (baseline)", :type => :feature do
  before(:each) { visit("/") }

  it "audits the accessible region (single document, no iframe)" do
    expect(page).to be_axe_clean.within "#content"
  end

  it "flags the inaccessible region" do
    expect(page).not_to be_axe_clean.within "#bad"
  end
end

describe "axe under Cuprite with iframes", :type => :feature do
  before(:each) { visit("/with-iframe") }

  it "raises instead of false-greening whole-page iframe audits" do
    expect {
      expect(page).to be_axe_clean
    }.to raise_error(/iframe auditing is not supported/)
  end

  it "raises instead of false-greening explicit iframe contexts" do
    expect {
      expect(page).to be_axe_clean.within iframe: "#child", selector: "#bad"
    }.to raise_error(/iframe auditing is not supported/)
  end

  it "audits only the top-level document when iframe auditing is skipped" do
    original_skip_iframes = Axe::Configuration.instance.skip_iframes
    Axe::Configuration.instance.skip_iframes = true

    expect(page).to be_axe_clean
  ensure
    Axe::Configuration.instance.skip_iframes = original_skip_iframes
  end
end
