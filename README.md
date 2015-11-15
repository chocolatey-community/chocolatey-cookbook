[![Cookbook Version](https://img.shields.io/cookbook/v/chocolatey.svg)](https://supermarket.getchef.com/cookbooks/chocolatey) [![Build Status](http://img.shields.io/travis/chocolatey/chocolatey-cookbook/master.svg)](https://travis-ci.org/chocolatey/chocolatey-cookbook)

# Description

Install Chocolatey with the default recipe and manage packages with a handy resource/provider.

# Requirements

## Platform:

* Windows
* Chef 11.6 or greater

## Cookbooks:

* windows (~> 1.31)

# Notes

As of Chocolatey version
[0.9.8.24](https://github.com/chocolatey/chocolatey/blob/master/CHANGELOG.md#09824-july-3-2014)
the install directory for Chocolatey has changed from `C:\Chocolatey` to
`C:\ProgramData\Chocolatey`.

More information can be gotten from the [Chocolateywiki](https://github.com/chocolatey/chocolatey/wiki/DefaultChocolateyInstallReasoning).

# Attributes

All attributes below are pre-pended with `node['chocolatey']`

Attribute | Description | Type   | Default
----------|-------------|--------|--------
`['url']` | Chocolatey installation script URL | String | https://chocolatey.org/install.ps1
`['upgrade']` | Whether to upgrade Chocolatey if it's already installed | Boolean | true
`['install_vars']['chocolateyProxyLocation']` | HTTPS proxy for Chocolatey install script | String | Chef::Config['https_proxy'] or ENV['https_proxy']
`['install_vars']['chocolateyProxyUser']` | Proxy user for authenticating proxies | String | nil
`['install_vars']['chocolateyProxyPassword']` | Proxy user password | String | nil
`['install_vars']['chocolateyVersion']` | Version of Chocolatey to install, e.g. '0.9.9.11' | String | nil (download latest version)
`['install_vars']['chocolateyDownloadUrl']` | Chocolatey .nupkg file URL. Use this if you host an internal copy of the chocolatey.nupkg | String | nil (download from chocolatey.org)


# Recipes

* chocolatey::default

# Resources

* [chocolatey](#chocolatey)

## chocolatey

### Actions

- install: Install a chocolatey package (default)
- remove: Uninstall a chocolatey package
- upgrade: Update a chocolatey package

### Resource Properties

- package: package to manage (default name)
- source: The source to find the package(s) to install
- version: The version of the package to use.
- args: arguments to the installation.
- options: Hash of additional options to be sent to `choco.exe`

# Examples

``` ruby
include_recipe 'chocolatey'

%w{sysinternals 7zip notepadplusplus GoogleChrome Console2}.each do |pack|
  chocolatey pack
end

%w{bash openssh grep}.each do |pack|
  chocolatey pack do
    source 'cygwin'
  end
end

chocolatey 'git.install' do
    options ({ 'params' => "'/GitOnlyOnPath'" })
end

chocolatey 'wireshark' do
  version '1.12.6'
  action :install
end

chocolatey "some_private_secure_package" do
  source "https://some.proget/feed"
  options ({'u' => 'username', 'p' => 'password'})
end

chocolatey 'DotNet4.5'

chocolatey 'PowerShell'
```

# License and Maintainer

Maintainer:: Guilhem Lettron (<guilhem@lettron.fr>)

License:: Apache 2.0
