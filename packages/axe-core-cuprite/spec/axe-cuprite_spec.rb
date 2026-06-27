require "spec_helper"
require "axe-cuprite"

RSpec.describe AxeCuprite do
  before { Axe::Configuration.instance.page = nil }

  it "raises without a configure block" do
    expect { AxeCuprite.configure }.to raise_error(ArgumentError, /configure block/)
  end

  it "sets Axe::Configuration#page to a Cuprite driver" do
    AxeCuprite.configure do |config|
      expect(config.page).to be_a(Capybara::Cuprite::Driver)
    end
  end

  it "accepts driver options as a positional hash" do
    AxeCuprite.configure(headless: true, window_size: [1200, 800]) do |config|
      expect(config.page).to be_a(Capybara::Cuprite::Driver)
    end
  end
end
