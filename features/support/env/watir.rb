require_relative '../env'
require 'watir'

Before do
  @page = Watir::Browser.new $browser

  # expose #visit method ala Capybara
  define_singleton_method :visit do |url|
    @page.goto url
  end
end

After do
  @page.close
end
