[![Gem Version](https://badge.fury.io/rb/bento-ya.svg)](http://badge.fury.io/rb/bento-ya)

# bento-ya
A RubyGem for managing chef/bento builds

## Requirements

* [Packer](https://www.packer.io/)
* At least one virtualization provider: VirtualBox, VMware Fusion, Parallels Desktop, etc

## Quick Start

Bento-ya is a RubyGem and can be installed with:

```
$ gem install bento-ya
```

If you use Bundler, you can add `gem "bento-ya"` to your Gemfile and make
sure to run `bundle install`.

### Using `bento`

To build multiple templates for all providers (VirtualBox, Fusion, Parallels, etc):

    $ bento build debian-8.6-amd64 debian-8.6-i386

To build a box for a single provider:

    $ bento build --only=virtualbox-iso debian-8.6-amd64

## Versioning

bento-ya aims to adhere to [Semantic Versioning 2.0.0][semver].

## License

Apache License, Version 2.0 (see [LICENSE][license])

[license]: https://github.com/cheeseplus/bento-ya/blob/master/LICENSE
