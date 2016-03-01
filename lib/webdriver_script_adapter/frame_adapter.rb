require 'dumb_delegator'

module WebDriverScriptAdapter
  class FrameAdapter < ::DumbDelegator

    def self.wrap(driver)
      if driver.respond_to?(:within_frame)
        driver
      elsif driver.switch_to.respond_to?(:parent_frame)
        new driver
      else
        ParentlessFrameAdapter.new driver
      end
    end

    def within_frame(frame)
      switch_to.frame(frame)
      yield
    ensure
      switch_to.parent_frame
    end

    private

    # Selenium Webdriver < 2.43 doesnt support moving back to the parent
    class ParentlessFrameAdapter < ::DumbDelegator

      # storage of frame stack (for reverting to parent) taken from Capybara
      # : https://github.com/jnicklas/capybara/blob/2.6.2/lib/capybara/selenium/driver.rb#L117-L147
      #
      # There doesnt appear to be any way in Selenium Webdriver < 2.43 to move back to a parent frame
      # other than going back to the root and then reiterating down
      def within_frame(frame)
        @frame_stack[window_handle] ||= []
        @frame_stack[window_handle] << frame

        switch_to.frame(frame)
        yield
      ensure
        @frame_stack[window_handle].pop
        switch_to.default_content
        @frame_stack[window_handle].each { |f| switch_to.frame(f) }
      end
    end

  end
end
