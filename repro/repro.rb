require "selenium-webdriver"
require_relative "../packages/axe-core-api/lib/axe/api/run"
require "json"

puts Gem.loaded_specs["selenium-webdriver"].version


driver = Selenium::WebDriver.for :safari
driver.navigate.to "http://google.com"
# driver.navigate.to "https://dequeuniversity.com/demo/mars/"
res = Axe::Core.new(driver).call Axe::API::Run.new.with_options

puts JSON.pretty_generate res.results.to_h

driver.quit