module Axe
  module VERSION
    MAJOR=1
    MINOR=1
    PATCH=1
    PRE=nil

    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join(".")
    end
  end
end
