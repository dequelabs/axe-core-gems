require 'axe/configuration'

module Axe
  def self.configure
    yield Configuration.instance if block_given?
  end
end
