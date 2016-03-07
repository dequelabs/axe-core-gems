require 'axe/configuration'
require 'axe/version'

module Axe
  def self.configure
    yield Configuration.instance if block_given?
  end
end
