# Changelog for Chocolatey cookbook

### Unreleased

* Refactored install script (and .kitchen.yml) to support installing Chocolatey
in test-kitchen behind a proxy.
* Remove `node['chocolatey']['Uri']` attribute. Instead, install by downloading
the chocolatey.nupkg directly via Chef's `remote_file` resource. This lets users
install via Chef client.rb proxy settings instead of inheriting Internet Explorer
proxy settings.
* Changed helpers module namespacing from: `ChocolateyHelpers` to `Chocolatey::Helpers`
* Add ChefSpec unit tests
* Add ServerSpec integration tests
* Gemfile: bump foodcritic to 5.0 and Berkshelf to 4.0
* Add ChefSpec matchers

### v0.4.1 (2015-10-15)

* Adds example how to install package with version
* use the vanilla script resource to bypass 64bit interpreter builder introduced in Chef 12.5

### v0.4.0 (2015-06-30)

* Refactor script to download Chocolatey install script
* Chocolatey install: add proxy support
* fix for 64-bit chocolatey installs

### v0.3.0 (2015-04-20)

* Support for chocolatey >= 0.9.9
* Make package name case insensitive

### v0.2.0 (2014-09-24)

* Allow spaces in the path to the "choco" command.
* Update tests to use Rakefile
* Support Chocolatey version 0.9.8.24+
* Support custom command line options when installing packages

### v0.1.0 (2014-02-20)

* Fix and tests

### v0.0.5 (2013-04-30)

* Initial release
