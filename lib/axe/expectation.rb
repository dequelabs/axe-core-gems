module Axe
  class AccessibilityExpectation
    def self.create(negate=false)
      negate ? InaccessibleExpectation.new : AccessibleExpectation.new
    end
  end

  class AccessibleExpectation
    def assert(page, matcher)
      raise matcher.failure_message unless matcher.matches? page
    end
  end

  class InaccessibleExpectation
    def assert(page, matcher)
      raise matcher.failure_message_when_negated if matcher.matches? page
    end
  end
end
