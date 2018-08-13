# Change Log

## [v1.1.1](https://github.com/cheeseplus/bento-ya/tree/v1.1.1) (2018-08-13)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v1.1.0...v1.1.1)

**Closed issues:**

- disable synced\_folder for Hyper-V provider [\#37](https://github.com/cheeseplus/bento-ya/issues/37)
- use full paths for `box\_url` in kitchen.yml [\#36](https://github.com/cheeseplus/bento-ya/issues/36)

**Merged pull requests:**

- This fixes Windows Hyper-V builders [\#39](https://github.com/cheeseplus/bento-ya/pull/39) ([cheeseplus](https://github.com/cheeseplus))

## [v1.1.0](https://github.com/cheeseplus/bento-ya/tree/v1.1.0) (2018-01-02)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v1.0.1...v1.1.0)

### NEW FEATURE

* Support for uploading to N and N.N slugs via builds.yml 

## [v1.0.1](https://github.com/cheeseplus/bento-ya/tree/v1.0.1) (2017-09-14)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v1.0.0...v1.0.1)

### BUG FIXES

* Fix normalize
* Fix release

## [v1.0.0](https://github.com/cheeseplus/bento-ya/tree/v1.0.0) (2017-09-05)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.1.4...v1.0.0)

### IMPROVEMENTS

* Use `vagrant_cloud` gem
* Refactor all Vagrant Cloud related code
* cleanup deps, options, style
* drop remote build support
* add Chefstyle
* configure TravisCI
* moved more things out of bento and into bento-ya
* support for loading `builds.yml`
* support folder re-organzation in bento project

### BUG FIXES

* Fix provider being set incorrectly for VMware builds

## [v0.1.4](https://github.com/cheeseplus/bento-ya/tree/v0.1.4) (2017-07-05)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.1.3...v0.1.4)

**Merged pull requests:**

- TravisCI doesn't have vagrant so punt [\#24](https://github.com/cheeseplus/bento-ya/pull/24) ([cheeseplus](https://github.com/cheeseplus))

## [v0.1.3](https://github.com/cheeseplus/bento-ya/tree/v0.1.3) (2017-07-05)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.1.2...v0.1.3)

**Merged pull requests:**

- Release 0.1.3 [\#23](https://github.com/cheeseplus/bento-ya/pull/23) ([cheeseplus](https://github.com/cheeseplus))
- Fixing require and attr reader for test [\#22](https://github.com/cheeseplus/bento-ya/pull/22) ([cheeseplus](https://github.com/cheeseplus))

## [v0.1.2](https://github.com/cheeseplus/bento-ya/tree/v0.1.2) (2017-07-05)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.1.1...v0.1.2)

**Merged pull requests:**

- Release 0.1.2 [\#21](https://github.com/cheeseplus/bento-ya/pull/21) ([cheeseplus](https://github.com/cheeseplus))
- Cleanup some requires [\#20](https://github.com/cheeseplus/bento-ya/pull/20) ([cheeseplus](https://github.com/cheeseplus))
- Testing of shared folder now default, option inverted [\#18](https://github.com/cheeseplus/bento-ya/pull/18) ([cheeseplus](https://github.com/cheeseplus))
- Fix typo in README.md [\#17](https://github.com/cheeseplus/bento-ya/pull/17) ([ffmike](https://github.com/ffmike))

## [v0.1.1](https://github.com/cheeseplus/bento-ya/tree/v0.1.1) (2017-07-03)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.1.0...v0.1.1)

**Merged pull requests:**

- Release 0.1.1 [\#16](https://github.com/cheeseplus/bento-ya/pull/16) ([cheeseplus](https://github.com/cheeseplus))
- Need mixlib-shellout [\#15](https://github.com/cheeseplus/bento-ya/pull/15) ([cheeseplus](https://github.com/cheeseplus))
- Fix renamed method [\#14](https://github.com/cheeseplus/bento-ya/pull/14) ([cheeseplus](https://github.com/cheeseplus))

## [v0.1.0](https://github.com/cheeseplus/bento-ya/tree/v0.1.0) (2017-06-30)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.0.3...v0.1.0)

**Closed issues:**

- Make CPU and Memory settings flexible [\#10](https://github.com/cheeseplus/bento-ya/issues/10)

**Merged pull requests:**

- Release 0.1.0 [\#12](https://github.com/cheeseplus/bento-ya/pull/12) ([cheeseplus](https://github.com/cheeseplus))
- Refactor for Vagrant Cloud [\#11](https://github.com/cheeseplus/bento-ya/pull/11) ([cheeseplus](https://github.com/cheeseplus))

## [v0.0.3](https://github.com/cheeseplus/bento-ya/tree/v0.0.3) (2017-02-22)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.0.2...v0.0.3)

**Merged pull requests:**

- Release 0.0.3 [\#9](https://github.com/cheeseplus/bento-ya/pull/9) ([cheeseplus](https://github.com/cheeseplus))
- Cleaning up code and fixing normalize [\#8](https://github.com/cheeseplus/bento-ya/pull/8) ([cheeseplus](https://github.com/cheeseplus))

## [v0.0.2](https://github.com/cheeseplus/bento-ya/tree/v0.0.2) (2017-02-19)
[Full Changelog](https://github.com/cheeseplus/bento-ya/compare/v0.0.1...v0.0.2)

**Closed issues:**

- bento terminates if prlctl is not available. [\#4](https://github.com/cheeseplus/bento-ya/issues/4)
- Gemspec Homepage Incorrect [\#3](https://github.com/cheeseplus/bento-ya/issues/3)

**Merged pull requests:**

- Cutting 0.0.2 [\#7](https://github.com/cheeseplus/bento-ya/pull/7) ([cheeseplus](https://github.com/cheeseplus))
- Fixes \#3 [\#6](https://github.com/cheeseplus/bento-ya/pull/6) ([cheeseplus](https://github.com/cheeseplus))
- deal with executables missing [\#5](https://github.com/cheeseplus/bento-ya/pull/5) ([karcaw](https://github.com/karcaw))

## [v0.0.1](https://github.com/cheeseplus/bento-ya/tree/v0.0.1) (2016-12-19)
**Merged pull requests:**

- Cutting 0.0.1 [\#2](https://github.com/cheeseplus/bento-ya/pull/2) ([cheeseplus](https://github.com/cheeseplus))
- let there be files [\#1](https://github.com/cheeseplus/bento-ya/pull/1) ([cheeseplus](https://github.com/cheeseplus))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
