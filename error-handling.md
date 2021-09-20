# Error Handling

## Table of Content
  1. [Having an Out-of-date Driver](#having-an-out-of-date-driver)
  1. [Having Popup blockers enabled](#having-popup-blockers-enabled)
  1. [AxeBuilder.setLegacyMode(legacy: boolean)](#axebuildersetlegacymodelegacy-boolean)




Version 4.3.0 and above of the axe-core integrations use a new technique when analyzing a page, which opens a new window at the end of a run. Many of the issues outlined in this document address common problems with this technique and their potential solutions.

### Having an Out-of-date Driver

A common problem is having an out-of-date driver. To fix this issue make sure that your local install of [geckodriver](https://github.com/mozilla/geckodriver/releases) or [chromedriver](https://chromedriver.chromium.org/downloads) is up-to-date.

An example error message for this problem will include a message about `switchToWindow`. 

Example: 

```console
(node:17566) UnhandledPromiseRejectionWarning: Error: Malformed type for "handle" parameter of command switchToWindow
Expected: string
Actual: undefined
```

### Having Popup blockers enabled

Popup blockers prevent us from opening the new window when analyzing a page. The default configuration for most automation testing libraries should allow popups. Please make sure that you do not explicitly enable popup blockers which may cause an issue while running the tests.

### AxeBuilder::setLegacyMode(boolean legacy)

If for some reason you are unable to analyze a page without errors, axe provides a new chainable method that allows you to run the legacy procedure. When using this method axe excludes accessibility issues that may occur in cross-domain frames and iframes.

**Please Note:** `Axe::Configuration.legacy_mode` is deprecated and will be removed in v5.0. Please report any errors you may have while analyzing a page so that they can be fixed before the legacy version is removed.

#### Example:

```ruby
require "axe/core"

def analyze_page
  ...
end
def open_page
  ...
end

webdriver = open_page
Axe::Configuration.instance.legacy_mode = true
results = analyze_page
```
