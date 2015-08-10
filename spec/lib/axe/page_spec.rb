require 'axe/page'

module Axe
  describe Page do

    subject { described_class.new double('driver', :execute_script => :foo) }

    it { is_expected.to respond_to :execute_script }
    it { is_expected.to respond_to :execute_async_script }
  end
end
