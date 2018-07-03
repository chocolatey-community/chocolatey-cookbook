# Changelog for Chocolatey cookbook

## v2.0.1 (2018-07-03)

- Remove mentions of the package provider from the readme and metadata

## v2.0.0 (2018-05-01)

### Breaking Change

The package LWRP has been removed from this cookbook. chocolatey_package was integrated into Chef 12.7, which was released in Feb 2016\. This cookbook now requires Chef 12.7 or later.

### Other Changes

- This cookbook no longer requires the Windows cookbook
- The install script has been updated to the latest Chocolatey install script
- Converted testing to use Delivery Local Mode from within ChefDK

## v1.2.1 (2017-08-20)

- Explicitly use the double-dash long option names for `--source` and `--installargs`

## v1.2.0 (2017-05-04)

- Change the default `['chocolatey']['upgrade']` attribute value to `false`. Preventing chocolatey from reinstalling every chef run

## v1.1.1 (2017-04-22)

- Fix chef 13 converges renaming conflicting `env_path` method

## v1.1.0 (2017-01-09)

- Update the chocolatey install script to match chocolatey.org.

## v1.0.3 (2016-09-12)

- Loosen windows-cookbook constraint

## v1.0.2 (2016-08-29)

- Ensure `chocolateyVersion` attribute is used and the correct version of chocolatey is installed.

## v1.0.1 (2016-07-15)

- Always execute chocolatey installer unless guard is satisfied to allow the install to retry on subsequent attempts if it fails.

## v1.0.0 (2016-03-07)

- No longer dependent on chocolatey.org for install script
- Removed deprecated overwriting of the current_resource and fixed visibility problem with `env_path`

## v0.6.2 (2016-01-07)

- Fix Chocolatey detection on chef clients older than 12.4.0

## v0.6.1 (2015-11-24)

- Fix LocalJumpError on existing chocolatey package

## v0.6.0 (2015-11-17)

- Path Tracking. Tracking additions to the user and machine %PATH% environment and merging them into the current process.
- Downcase package name results from choco upgrade.

## v0.5.1 (2015-11-10)

- Prepend library include with :: in provder to fix 12.3.0 and likely other versions older than 12.5.1.
- Add backward compatibiliy to new metadata.rb attributes `source_url` and `issues_url`.

## v0.5.0 (2015-11-09)

- Refactored install script (and .kitchen.yml) to support installing Chocolatey in test-kitchen behind a proxy.
- Download `node['chocolatey']['Uri']` via `remote_file` resource instead of .net web client
- Set `chocolateyProxyLocation` environment variable to `Chef::Config['https_proxy']` if one is set before chocolatey install
- Changed helpers module namespacing from: `ChocolateyHelpers` to `Chocolatey::Helpers`
- Add ChefSpec unit tests
- Add ServerSpec integration tests
- Gemfile: bump foodcritic to 5.0 and Berkshelf to 4.0
- Add ChefSpec matchers

## v0.4.1 (2015-10-15)

- Adds example how to install package with version
- use the vanilla script resource to bypass 64bit interpreter builder introduced in Chef 12.5

## v0.4.0 (2015-06-30)

- Refactor script to download Chocolatey install script
- Chocolatey install: add proxy support
- fix for 64-bit chocolatey installs

## v0.3.0 (2015-04-20)

- Support for chocolatey >= 0.9.9
- Make package name case insensitive

## v0.2.0 (2014-09-24)

- Allow spaces in the path to the "choco" command.
- Update tests to use Rakefile
- Support Chocolatey version 0.9.8.24+
- Support custom command line options when installing packages

## v0.1.0 (2014-02-20)

- Fix and tests

## v0.0.5 (2013-04-30)

- Initial release
