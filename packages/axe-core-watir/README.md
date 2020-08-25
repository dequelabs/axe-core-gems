# `axe-core-watir`

The `axe-core-watir` gem provides a chainable [axe API][] for [Watir][] and automatically injects into all frames.

## Usage

- In your Gemfile, add the `axe-core-watir` gem.

```Gemfile
source "https://rubygems.org"

gem 'axe-core-watir'
```

- Require `axe-watir` and use the exported member `AxeWatir`.

```rb
require 'axe-watir'

# configure `AxeWatir`
driver = AxeWatir.configure(:firefox) do |c|
  # see below for a full list of configuration 
  c.jslib_path = "next-version/axe.js"
end

# use the driver configuration instance
driver.page.goto 'https://www.deque.com/'
```

### API 

#### `AxeWatir.configure`

The configure method takes 1 optional argument as a [symbol][] and a configuration block object: `configure(*arg, &block)`

The optional argument is a browser name for `watir`. The valid browser names are:
- `:firefox` 
- `:chrome` (default)
- `:safari`
- `:internet_explorer`
- `:edge`

A detailed configuration option for each of the browsers are available in the [Watir documenation/ guide](http://watir.com/guides/)

> Note: Please ensure respective drivers (eg: [`geckodriver`][]) are installed in your machine.

The block configuration object contains the below properties:

| Property | Type | Description |
|---|---|---|
| `jslib_path` (Optional) | `String` | Path to a custom `axe` source |
| `skip_iframes` (Optional) | `Boolean` | Indicate if frames should be excluded from injecting with `axe` |

## Development

> Note: Refer to [contributing guidelines](../../../CONTRIBUTING.md) for a full list of setup requirements.

Navigate to the directory of this gem - `src/packages/axe-core-watir`

Install dependencies (declared in `axe-core-watir.gemspec`):
```sh
bundle install
```

To run tests:
```
bundle exec rspec
```

[axe API]: https://github.com/dequelabs/axe-core/blob/develop/doc/API.md
[Watir]: http://watir.com/
[`geckodriver`]: https://github.com/mozilla/geckodriver/releases