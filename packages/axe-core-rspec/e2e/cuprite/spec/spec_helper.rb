require "rspec"
require "capybara/rspec"
require "capybara/cuprite"
require "axe-rspec"

# A known-accessible page and a known-inaccessible region, served in-process
# so the suite is deterministic and offline.
FIXTURE_HTML = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
    <head><meta charset="utf-8"><title>Cuprite axe fixture</title></head>
    <body>
      <main id="content">
        <h1>Accessible heading</h1>
        <p>Readable paragraph with sufficient contrast.</p>
      </main>
      <div id="bad">
        <img src="data:image/gif;base64,R0lGODlhAQABAAAAACw=">
      </div>
    </body>
  </html>
HTML

IFRAME_HTML = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
    <head><meta charset="utf-8"><title>Cuprite iframe fixture</title></head>
    <body>
      <main id="content">
        <h1>Parent document</h1>
        <iframe id="child" title="Child frame" src="/child"></iframe>
      </main>
    </body>
  </html>
HTML

CHILD_HTML = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
    <head><meta charset="utf-8"><title>Child fixture</title></head>
    <body>
      <h2>Child document</h2>
      <img id="bad" src="data:image/gif;base64,R0lGODlhAQABAAAAACw=">
    </body>
  </html>
HTML

Capybara.app = lambda do |env|
  html = case env["PATH_INFO"]
         when "/with-iframe" then IFRAME_HTML
         when "/child" then CHILD_HTML
         else FIXTURE_HTML
         end
  [200, { "Content-Type" => "text/html" }, [html]]
end

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], headless: true)
end

Capybara.default_driver = :cuprite
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  config.color = true
end
