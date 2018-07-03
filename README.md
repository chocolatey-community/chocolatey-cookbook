# chocolatey Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/chocolatey.svg)](https://supermarket.getchef.com/cookbooks/chocolatey) [![Build Status](http://img.shields.io/travis/chocolatey/chocolatey-cookbook/master.svg)](https://travis-ci.org/chocolatey/chocolatey-cookbook)

Install Chocolatey with the default recipe.

## Requirements

### Platform

- Windows

### Chef

- 12.7 or greater

## Notes

As of Chocolatey version [0.9.8.24](https://github.com/chocolatey/chocolatey/blob/master/CHANGELOG.md#09824-july-3-2014) the install directory for Chocolatey has changed from `C:\Chocolatey` to `C:\ProgramData\Chocolatey`.

More information can be gotten from the [Chocolateywiki](https://github.com/chocolatey/chocolatey/wiki/DefaultChocolateyInstallReasoning).

## Attributes

All attributes below are pre-pended with `node['chocolatey']`

Attribute                                            | Description                                                                               | Type    | Default
---------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------
`['upgrade']`                                        | Whether to upgrade Chocolatey if it's already installed                                   | Boolean | false
`['install_vars']['chocolateyProxyLocation']`        | HTTPS proxy for Chocolatey install script                                                 | String  | Chef::Config['https_proxy'] or ENV['https_proxy']
`['install_vars']['chocolateyProxyUser']`            | Proxy user for authenticating proxies                                                     | String  | nil
`['install_vars']['chocolateyProxyPassword']`        | Proxy user password                                                                       | String  | nil
`['install_vars']['chocolateyVersion']`              | Version of Chocolatey to install, e.g. '0.9.9.11'                                         | String  | nil (download latest version)
`['install_vars']['chocolateyDownloadUrl']`          | Chocolatey .nupkg file URL. Use this if you host an internal copy of the chocolatey.nupkg | String  | <https://chocolatey.org/api/v2/package/chocolatey> (download from chocolatey.org)
`['install_vars']['chocolateyUseWindowsCompression']`| To use built-in compression instead of 7zip (requires additional download) set to `true`  | String  | nil (use 7zip)

## Recipes

- `chocolatey::default` - installs Chocolatey

## License and Maintainer

Maintainer:: Guilhem Lettron ([guilhem@lettron.fr](mailto:guilhem@lettron.fr))

License:: Apache 2.0
