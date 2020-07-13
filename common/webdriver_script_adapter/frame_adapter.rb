require 'dumb_delegator'

module WebDriverScriptAdapter
  class FrameAdapter < ::DumbDelegator
    def self.wrap(driver)
      if driver.respond_to?(:within_frame)
        CapybaraAdapter.new driver
      elsif !driver.respond_to?(:switch_to)
        WatirAdapter.new driver
      elsif driver.switch_to.respond_to?(:parent_frame)
        SeleniumAdapter.new driver # add within_frame to selenium
      else
        ParentlessFrameAdapter.new driver # old selenium doesn't support parent_frame
      end
    end

    private

    class CapybaraAdapter < ::DumbDelegator
      def find_frames
        all(:css, 'iframe')
      end
    end

    class WatirAdapter < ::DumbDelegator
      # delegate to Watir's Selenium #driver
      def within_frame(frame, &block)
        SeleniumAdapter.instance_method(:within_frame).bind(FrameAdapter.wrap driver).call(frame, &block)
      end

      def find_frames
        driver.find_elements(:css, 'iframe')
      end
    end

    class SeleniumAdapter < ::DumbDelegator
      def within_frame(frame)
        switch_to.frame(frame)
        yield
      ensure
        begin
          switch_to.parent_frame
        rescue => e
          if /switchToParentFrame|frame\/parent/.match(e.message)
            ::Kernel.warn "WARNING: This browser only supports first-level iframes. Second-level iframes and beyond will not be audited. To skip auditing all iframes, set Axe::Configuration#skip_iframes=true"
          end
          switch_to.default_content
        end
      end

      def find_frames
        find_elements(:css, 'iframe')
      end
    end

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

    def find_frames
      find_elements(:css, 'iframe')
    end
  end
end
