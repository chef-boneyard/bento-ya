# Change Log

## [v1.2.0](https://github.com/chef/bento-ya/tree/v1.2.0) (2018-12-02)
[Full Changelog](https://github.com/chef/bento-ya/compare/v1.1.2...v1.2.0)

- Updated all mentions of Atlas to be Vagrant Cloud in the application and readme including the variables that need to be set to authenticate to Vagrant Cloud
- The app will now hard fail if VAGRANT_CLOUD_ORG or VAGRANT_CLOUD_TOKEN variables aren't set so you get a friendly error message
- Avoided nil split errors when there's no packer definition files found
- Updated OS X -> macOS everywhere
- Added examples to the help for --only and --except options so it's more clear what they do
- Resolved a nil error when running bento list
- Added a new --single option that disables parallel builds in Packer
- Slimed the gem down by removing dot files and the readme from the gem package
- Resolved all Chefstyle warnings
- Transferred the repo to github.com/chef and updatd all links to point to the new location
- Expanded Travis testing to all supported Ruby releases
- Removed the rspec deps since we don't actually have any specs yet


## [v1.1.2](https://github.com/chef/bento-ya/tree/v1.1.2) (2018-08-14)
[Full Changelog](https://github.com/chef/bento-ya/compare/v1.1.1...v1.1.2)

**Merged pull requests:**

- Alter share\_disabled regex to catch all BSDs [\#41](https://github.com/chef/bento-ya/pull/41) ([cheeseplus](https://github.com/chef))

## [v1.1.1](https://github.com/chef/bento-ya/tree/v1.1.1) (2018-08-13)
[Full Changelog](https://github.com/chef/bento-ya/compare/v1.1.0...v1.1.1)

**Closed issues:**

- disable synced\_folder for Hyper-V provider [\#37](https://github.com/chef/bento-ya/issues/37)
- use full paths for `box\_url` in kitchen.yml [\#36](https://github.com/chef/bento-ya/issues/36)

**Merged pull requests:**

- This fixes Windows Hyper-V builders [\#39](https://github.com/chef/bento-ya/pull/39) ([cheeseplus](https://github.com/chef))

## [v1.1.0](https://github.com/chef/bento-ya/tree/v1.1.0) (2018-01-02)
[Full Changelog](https://github.com/chef/bento-ya/compare/v1.0.1...v1.1.0)

### NEW FEATURE

* Support for uploading to N and N.N slugs via builds.yml

## [v1.0.1](https://github.com/chef/bento-ya/tree/v1.0.1) (2017-09-14)
[Full Changelog](https://github.com/chef/bento-ya/compare/v1.0.0...v1.0.1)

### BUG FIXES

* Fix normalize
* Fix release

## [v1.0.0](https://github.com/chef/bento-ya/tree/v1.0.0) (2017-09-05)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.1.4...v1.0.0)

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

## [v0.1.4](https://github.com/chef/bento-ya/tree/v0.1.4) (2017-07-05)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.1.3...v0.1.4)

**Merged pull requests:**

- TravisCI doesn't have vagrant so punt [\#24](https://github.com/chef/bento-ya/pull/24) ([cheeseplus](https://github.com/chef))

## [v0.1.3](https://github.com/chef/bento-ya/tree/v0.1.3) (2017-07-05)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.1.2...v0.1.3)

**Merged pull requests:**

- Release 0.1.3 [\#23](https://github.com/chef/bento-ya/pull/23) ([cheeseplus](https://github.com/chef))
- Fixing require and attr reader for test [\#22](https://github.com/chef/bento-ya/pull/22) ([cheeseplus](https://github.com/chef))

## [v0.1.2](https://github.com/chef/bento-ya/tree/v0.1.2) (2017-07-05)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.1.1...v0.1.2)

**Merged pull requests:**

- Release 0.1.2 [\#21](https://github.com/chef/bento-ya/pull/21) ([cheeseplus](https://github.com/chef))
- Cleanup some requires [\#20](https://github.com/chef/bento-ya/pull/20) ([cheeseplus](https://github.com/chef))
- Testing of shared folder now default, option inverted [\#18](https://github.com/chef/bento-ya/pull/18) ([cheeseplus](https://github.com/chef))
- Fix typo in README.md [\#17](https://github.com/chef/bento-ya/pull/17) ([ffmike](https://github.com/ffmike))

## [v0.1.1](https://github.com/chef/bento-ya/tree/v0.1.1) (2017-07-03)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.1.0...v0.1.1)

**Merged pull requests:**

- Release 0.1.1 [\#16](https://github.com/chef/bento-ya/pull/16) ([cheeseplus](https://github.com/chef))
- Need mixlib-shellout [\#15](https://github.com/chef/bento-ya/pull/15) ([cheeseplus](https://github.com/chef))
- Fix renamed method [\#14](https://github.com/chef/bento-ya/pull/14) ([cheeseplus](https://github.com/chef))

## [v0.1.0](https://github.com/chef/bento-ya/tree/v0.1.0) (2017-06-30)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.0.3...v0.1.0)

**Closed issues:**

- Make CPU and Memory settings flexible [\#10](https://github.com/chef/bento-ya/issues/10)

**Merged pull requests:**

- Release 0.1.0 [\#12](https://github.com/chef/bento-ya/pull/12) ([cheeseplus](https://github.com/chef))
- Refactor for Vagrant Cloud [\#11](https://github.com/chef/bento-ya/pull/11) ([cheeseplus](https://github.com/chef))

## [v0.0.3](https://github.com/chef/bento-ya/tree/v0.0.3) (2017-02-22)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.0.2...v0.0.3)

**Merged pull requests:**

- Release 0.0.3 [\#9](https://github.com/chef/bento-ya/pull/9) ([cheeseplus](https://github.com/chef))
- Cleaning up code and fixing normalize [\#8](https://github.com/chef/bento-ya/pull/8) ([cheeseplus](https://github.com/chef))

## [v0.0.2](https://github.com/chef/bento-ya/tree/v0.0.2) (2017-02-19)
[Full Changelog](https://github.com/chef/bento-ya/compare/v0.0.1...v0.0.2)

**Closed issues:**

- bento terminates if prlctl is not available. [\#4](https://github.com/chef/bento-ya/issues/4)
- Gemspec Homepage Incorrect [\#3](https://github.com/chef/bento-ya/issues/3)

**Merged pull requests:**

- Cutting 0.0.2 [\#7](https://github.com/chef/bento-ya/pull/7) ([cheeseplus](https://github.com/chef))
- Fixes \#3 [\#6](https://github.com/chef/bento-ya/pull/6) ([cheeseplus](https://github.com/chef))
- deal with executables missing [\#5](https://github.com/chef/bento-ya/pull/5) ([karcaw](https://github.com/karcaw))

## [v0.0.1](https://github.com/chef/bento-ya/tree/v0.0.1) (2016-12-19)
**Merged pull requests:**

- Cutting 0.0.1 [\#2](https://github.com/chef/bento-ya/pull/2) ([cheeseplus](https://github.com/chef))
- let there be files [\#1](https://github.com/chef/bento-ya/pull/1) ([cheeseplus](https://github.com/chef))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
