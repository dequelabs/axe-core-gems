module CustomA11yMatchers
  class BeAccessible

    def matches?(page)
      @page = page
      true
    end
  end

  def be_accessible
    BeAccessible.new
  end
end
