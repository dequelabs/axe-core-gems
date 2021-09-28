# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [4.3.2](https://github.com/dequelabs/axe-core-gems/compare/v4.3.1...v4.3.2) (2021-09-27)


### Bug Fixes

* finishRun stack overflow ([#220](https://github.com/dequelabs/axe-core-gems/issues/220)) ([75130b0](https://github.com/dequelabs/axe-core-gems/commit/75130b01192ab9b48b11596c157125f395251830))

### [4.3.1](https://github.com/dequelabs/axe-core-gems/compare/v4.3.0...v4.3.1) (2021-09-22)


### Bug Fixes

* update error-handling link to correct url ([#212](https://github.com/dequelabs/axe-core-gems/issues/212)) ([5d6d4c3](https://github.com/dequelabs/axe-core-gems/commit/5d6d4c3702eef4c80544b588b7b7352442045b85))

## [4.3.0](https://github.com/dequelabs/axe-core-gems/compare/v4.2.1...v4.3.0) (2021-09-20)


### Features

* add legacy mode and 4.3.x tests ([#202](https://github.com/dequelabs/axe-core-gems/issues/202)) ([4575cbd](https://github.com/dequelabs/axe-core-gems/commit/4575cbdcecb76a372e216f3ced07b7d26e309c69))

### [4.2.1](https://github.com/dequelabs/axe-core-gems/compare/v4.2.0...v4.2.1) (2021-06-16)


### Features

* update to use `axe-core@4.2.2` ([#192](https://github.com/dequelabs/axe-core-gems/issues/192)) ([bb86ed5](https://github.com/dequelabs/axe-core-gems/commit/bb86ed5bd0b532897522153868077e8b0f564280))

## [4.1.0](https://github.com/dequelabs/axe-core-gems/compare/v4.0.0...v4.1.0) (2021-05-20)


### Features

* bump axe-core to 4.2.0 ([#181](https://github.com/dequelabs/axe-core-gems/issues/181)) ([2bf4a90](https://github.com/dequelabs/axe-core-gems/commit/2bf4a90c7785cd9245da6a0774903b940d05f87d))
* bump axe-core to v4.1.2 ([#172](https://github.com/dequelabs/axe-core-gems/issues/172)) ([f26d625](https://github.com/dequelabs/axe-core-gems/commit/f26d6255712c2ccbb90ef77c129411ff432cb0cc))
* update axe-core to 4.2.1 ([#187](https://github.com/dequelabs/axe-core-gems/issues/187)) ([a8e5044](https://github.com/dequelabs/axe-core-gems/commit/a8e5044acce9c4c758d5ba71a7f14fc14b62094d))


### Bug Fixes

* correctly run on iframes ([#185](https://github.com/dequelabs/axe-core-gems/issues/185)) ([c46720b](https://github.com/dequelabs/axe-core-gems/commit/c46720b72ac42a34d57cf14531e50ccf659914d3))

## [4.1.0](https://github.com/dequelabs/axe-core-gems/compare/v4.0.0...v4.1.0) (2020-11-18)


### Features

* Update axe-core to v4.1.0



# [4.0.0](https://github.com/dequelabs/axe-core-gems/compare/v2.6.0...v4.0.0) (2020-08-25)


### Features

- feat: rename `BeAccessible` to `BeAxeClean` (#138) [b702a53](https://github.com/dequelabs/axe-core-gems/commit/b702a53ba770c73f8a3e35cf2633697e46f0e4be) 
- feat: `axe-core-api` gem (#113) [d8acb9d](https://github.com/dequelabs/axe-core-gems/commit/d8acb9d662e6a6748c67019cb0b5708543eff34c) 
- feat: `axe-core-cucumber` gem (#105) [a0f5d77](https://github.com/dequelabs/axe-core-gems/commit/a0f5d7794c990af13e96e882b1cd5ea593e2a002) 
- feat: `axe-core-rspec` gem (#104) [6acf37c](https://github.com/dequelabs/axe-core-gems/commit/6acf37c185fb739c03a407b737dd6fc8a2fc4b69) 
- feat: `axe-core-capybara` gem (#103) [aad434d](https://github.com/dequelabs/axe-core-gems/commit/aad434d691878c6a5696fb02606ffbb98b51ea26) 
- feat: `axe-core-watir` gem (#102) [4831ab1](https://github.com/dequelabs/axe-core-gems/commit/4831ab1ff773938e8433c5aecd0842c710a515be) 
- feat: `axe-core-selenium` gem (#101) [f1f203c](https://github.com/dequelabs/axe-core-gems/commit/f1f203cde4790f6290d71f1309c247139f954f73) 


### Bug Fixes

- fix: use `axe-core-api` gem in `axe-core-watir` gem (#118) [16ab9cd](https://github.com/dequelabs/axe-core-gems/commit/16ab9cdc1b28db226f441c8b609523f68ad0bc37) 
- fix: use `axe-core-api` gem in `axe-core-selenium` gem (#117) [9c1c93c](https://github.com/dequelabs/axe-core-gems/commit/9c1c93cbf31b984b976da5219b66019018e3f62c) 
- fix: use `axe-core-api` gem in `axe-core-rspec` gem (#116) [6144aa9](https://github.com/dequelabs/axe-core-gems/commit/6144aa963a4808165f4606a95d6b60c4f9068456) 
- fix: use `axe-core-api` gem in `axe-core-cucumber` gem (#115) [39fd531](https://github.com/dequelabs/axe-core-gems/commit/39fd5319f914cc01b2924bd38ceca886411b5366) 
- fix: use `axe-core-api` gem in `axe-core-capybara` gem (#114) [c5f466a](https://github.com/dequelabs/axe-core-gems/commit/c5f466a5ce700303ff8f21043195fa833d20e853) 
- fix(axe-core-gems): add e2e tests and set up rake tasks (#110) [a8ac475](https://github.com/dequelabs/axe-core-gems/commit/a8ac475959a87b91f49de6e916834dcd456c84ee) 
- fix: allow to configure browser as a Symbol argument for webdrivers (#109) [9e116d7](https://github.com/dequelabs/axe-core-gems/commit/9e116d7b38fef5a77efbc503be8bc69c8ac0d9ff) 


### BREAKING CHANGES

- **axe-matchers** gem is deprecated. Refer [README](./README.md) for usage instructions on `axe-core-gems`



## [2.6.0](https://github.com/dequelabs/axe-core-gems/compare/v2.5.0...v2.6.0) (2020-02-18)


### Features

* update axe-core to v3.5.0 ([#88](https://github.com/dequelabs/axe-core-gems/issues/88)) ([04a5137](https://github.com/dequelabs/axe-core-gems/commit/04a5137))
* update axe-core to v3.5.1 ([#90](https://github.com/dequelabs/axe-core-gems/issues/90)) ([2728b62](https://github.com/dequelabs/axe-core-gems/commit/2728b62))



## [2.5.0](https://github.com/dequelabs/axe-core-gems/compare/v2.4.0...v2.5.0) (2019-11-06)


### Features

* update axe-core to v3.3.1 ([#71](https://github.com/dequelabs/axe-core-gems/issues/71)) ([bb347e5](https://github.com/dequelabs/axe-core-gems/commit/bb347e5))
* update axe-core to v3.4.0 ([#82](https://github.com/dequelabs/axe-core-gems/issues/82)) ([b83c8a0](https://github.com/dequelabs/axe-core-gems/commit/b83c8a0))


## [2.4.1](https://github.com/dequelabs/axe-core-gems/compare/v2.4.0...v2.4.1) (2019-07-29)


### Bug Fixes

* update axe-core to v3.3.1 ([#71](https://github.com/dequelabs/axe-core-gems/issues/71)) ([bb347e5](https://github.com/dequelabs/axe-core-gems/commit/bb347e5))



## [2.4.0](https://github.com/dequelabs/axe-core-gems/compare/v2.3.0...v2.4.0) (2019-07-11)

### Features

* not use named capture groups in cucumber step regex ([#64](https://github.com/dequelabs/axe-core-gems/issues/64)) ([4f118a1](https://github.com/dequelabs/axe-core-gems/commit/4f118a1))

### Features

* update axe-core to v3.3.0 ([#66](https://github.com/dequelabs/axe-core-gems/issues/66)) ([7204257](https://github.com/dequelabs/axe-core-gems/commit/7204257))

## [2.3.0](https://github.com/dequelabs/axe-core-gems/compare/v2.2.1...v2.3.0) (2019-03-06)


* Update axe-core to 3.2.2

### Features

* gems vulnerability by removing lock files in examples ([#53](https://github.com/dequelabs/axe-core-gems/issues/53)) ([648aeca](https://github.com/dequelabs/axe-core-gems/commit/648aeca))
* security vulnerability ([#52](https://github.com/dequelabs/axe-core-gems/issues/52)) ([14736f2](https://github.com/dequelabs/axe-core-gems/commit/14736f2))


<a name="2.2.1"></a>
## [2.2.1](https://github.com/dequelabs/axe-core-gems/compare/v2.1.1...v2.2.1) (2018-08-29)

### Features

* Update axe-core to 3.1.1


<a name="2.1.1"></a>
## [2.1.1](https://github.com/dequelabs/axe-core-gems/compare/v2.1.0...v2.1.1) (2018-05-16)

### Features

* Update axe-core to 3.0.2

### Bug Fixes

* Enhance results object with summary and target attributes to align with axe-core results


<a name="2.1.0"></a>
## [2.1.0](https://github.com/dequelabs/axe-core-gems/compare/v2.0.0...v2.0.1) (2018-04-20)

### Features

* Update axe-core to 3.0.1

### Bug Fixes

* Prevent Cucumber from choking on comments (#32)
* Defines serialization for Audit Results (#33)
