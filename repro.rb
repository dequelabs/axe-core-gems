require "selenium-webdriver"
require_relative "packages/axe-core-api/lib/axe/api/run"
require "json"

driver = Selenium::WebDriver.for :safari
# google is causing another error, apparently because it's fast
# driver.navigate.to "http://google.com"
driver.navigate.to "https://dequeuniversity.com/demo/mars/"

res = Axe::Core.new(driver).call Axe::API::Run.new.with_options

puts JSON.pretty_generate res.results.to_h

driver.quit

puts ( Object::RUBY_PLATFORM =~ /darwin/i ? true : false )