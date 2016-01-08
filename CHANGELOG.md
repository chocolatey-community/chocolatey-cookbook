# Changelog for Chocolatey cookbook

### v0.6.2 (2016-01-07)

* Fix Chocolatey detection on chef clients older than 12.4.0

### v0.6.1 (2015-11-24)

* Fix LocalJumpError on existing chocolatey package

### v0.6.0 (2015-11-17)

* Path Tracking. Tracking additions to the user and machine
  %PATH% environment and merging them into the current process.
* Downcase package name results from choco upgrade.

### v0.5.1 (2015-11-10)

* Prepend library include with :: in provder to fix 12.3.0 and likely other versions older than 12.5.1.
* Add backward compatibiliy to new metadata.rb attributes `source_url` and `issues_url`.

### v0.5.0 (2015-11-09)

* Refactored install script (and .kitchen.yml) to support installing Chocolatey in test-kitchen behind a proxy.
* Download `node['chocolatey']['Uri']` via `remote_file` resource instead of .net web client
* Set `chocolateyProxyLocation` environment variable to `Chef::Config['https_proxy']` if one is set before chocolatey install
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
