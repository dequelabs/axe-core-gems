require 'rspec/a11y/custom_matcher'

module CustomA11yMatchers
  describe "BeAccessible" do

    before :each do
      @matcher = BeAccessible.new
      @page = double("page")
    end

    context "#matches?" do

      it "should return true" do
        expect(@matcher.matches?(@page)).to eq(true)
      end
    end
  end
end
