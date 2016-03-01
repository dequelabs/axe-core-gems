require 'dumb_delegator'

module WebDriverScriptAdapter
  class FrameAdapter < ::DumbDelegator

    def self.wrap(driver)
      driver.respond_to?(:within_frame) ? driver : new(driver)
    end


    def within_frame(frame)
      # Selenium Webdriver < 2.43 doesnt support moving back to the parent
      (@frame_stack[window_handle] ||= []) << frame unless switch_to.respond_to?(:parent_frame)

      switch_to.frame(frame)
      yield

    ensure
      if switch_to.respond_to?(:parent_frame)
        switch_to.parent_frame
      else
        # There doesnt appear to be any way in Selenium Webdriver < 2.43 to move back to a parent frame
        # other than going back to the root and then reiterating down
        @frame_stack[window_handle].pop
        switch_to.default_content
        @frame_stack[window_handle].each { |f| switch_to.frame(f) }
      end
    end
  end

end
