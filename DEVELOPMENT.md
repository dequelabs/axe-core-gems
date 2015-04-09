## Development and Testing

This repository includes two sets of tests:

#### RSpec Unit Tests

These confirm the proper behavior of the RSpec matcher module. These are located in the `spec` directory and may be run with `rspec spec`.

#### Cucumber Feature Tests

These exist under the `features` directory that run against a simple Sinatra application loaded from `features/fixtures`. This can be used to try out Cucumber matchers against a simple application.

**Note:** Running these Cucumber tests requires first installing a copy of `kensington.min.js` into the directory at `features/fixtures/public`
