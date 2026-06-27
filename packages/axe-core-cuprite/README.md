# `axe-core-cuprite`

The `axe-core-cuprite` gem provides a chainable [axe API][] for [Cuprite][] (a Ferrum/Chrome DevTools Protocol Capybara driver). Current support is limited to top-level document audits; iframe auditing under Cuprite is not supported yet.

## Usage

- In your Gemfile, add the `axe-core-cuprite` gem.

```Gemfile
source "https://rubygems.org"

gem 'axe-core-cuprite'
gem 'cuprite'
```

The `axe-core-cuprite` gem assumes your application already depends on and configures `cuprite`. If not, add `gem 'cuprite'` to your application Gemfile.

- Require `axe-cuprite` and use the exported member `AxeCuprite`.

```rb
require 'axe-cuprite'
require 'axe-rspec'

# Configure AxeCuprite with optional driver options
AxeCuprite.configure(headless: true, window_size: [1200, 800]) do |config|
  # see below for a full list of configuration
  config.jslib_path = "next-version/axe.js"
end
```

- Use with Capybara and RSpec:

```rb
require 'capybara/rspec'
require 'axe-cuprite'
require 'axe-rspec'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, headless: true)
end

Capybara.default_driver = :cuprite
Capybara.javascript_driver = :cuprite

RSpec.describe "Accessibility", type: :feature do
  it "is accessible" do
    visit "https://www.example.com/"
    expect(page).to be_axe_clean
  end
end
```

### API

#### `AxeCuprite.configure`

The configure method takes an optional hash of driver options and requires a configuration block: `configure(options = {}, &block)`

The `options` hash is passed directly to `Capybara::Cuprite::Driver.new`. Common options include:

| Option | Type | Description |
|---|---|---|
| `headless` (Optional) | `Boolean` | Run Chrome in headless mode (default: true) |
| `window_size` (Optional) | `Array` | Browser window dimensions, e.g. `[1200, 800]` |
| `browser_options` (Optional) | `Hash` | Additional Chrome options |

The block configuration object (an `Axe::Configuration` instance) supports:

| Property | Type | Description |
|---|---|---|
| `jslib_path` (Optional) | `String` | Path to a custom `axe` source |
| `skip_iframes` (Optional) | `Boolean` | Permit top-level-only audits on pages that contain iframes |

## Known Limitations

Iframe auditing is not yet supported under Cuprite. Cuprite's `switch_to_frame`
resolves a frame only from a Capybara element, while axe's frame traversal passes
driver nodes. Top-level document audits are supported. Pages containing iframes
can be audited as top-level-only documents by setting
`Axe::Configuration#skip_iframes = true`; explicit `within(iframe: ...)` and
`excluding(iframe: ...)` contexts still raise an unsupported-driver error. Use a
Selenium-backed gem when iframe auditing is required.
Tracking: [#508](https://github.com/dequelabs/axe-core-gems/issues/508).

> Note: Please ensure [Google Chrome or Chromium][] is installed on your machine.

## Development

Navigate to the directory of this gem — `packages/axe-core-cuprite`

Install dependencies (declared in `axe-core-cuprite.gemspec`):
```sh
bundle install
```

To run tests:
```sh
bundle exec rspec
```

[axe API]: https://github.com/dequelabs/axe-core/blob/develop/doc/API.md
[Cuprite]: https://github.com/rubycdp/cuprite
[Google Chrome or Chromium]: https://www.google.com/chrome/
